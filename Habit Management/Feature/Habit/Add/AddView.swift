//
//  Add.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/31.
//

import SwiftUI
import ComposableArchitecture

struct AddView: View {
    let habitStore: StoreOf<HabitFeature>
    let statisticsStore: StoreOf<StatisticsFeature>
    let completionStore: StoreOf<CompletionFeature>

    @ObservedObject var textfield = TextLimiter()
    @State private var showingDeleteAlert = false

    init(
        habitStore: StoreOf<HabitFeature>,
        statisticsStore: StoreOf<StatisticsFeature>,
        completionStore: StoreOf<CompletionFeature>
    ) {
        self.habitStore = habitStore
        self.statisticsStore = statisticsStore
        self.completionStore = completionStore
    }

    var body: some View {
        WithViewStore(habitStore, observe: { $0 }) { viewStore in
            ZStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.vertical)
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .scaledFrame(width: .none, height: 280)
                            .scaledPadding(top: 0, leading: 5, bottom: 0, trailing: 5)
                            .foregroundColor(Color.white)

                        VStack(alignment: .center, spacing: 0) {
                            if viewStore.mode == .editing {
                                HStack {
                                    Spacer()
                                    Button("삭제") {
                                        showingDeleteAlert = true
                                    }
                                    .foregroundColor(.red)
                                    .scaledText(size: 15, weight: .semibold)
                                }
                                .scaledPadding(top: 12, leading: 25, bottom: 4, trailing: 20)
                            }

                            TextField("제목을 입력하세요", text: viewStore.binding(get: \.habitTitle, send: { .setHabitTitle($0) }))
                                .textFieldStyle(.roundedBorder)
                                .scaledText(size: 25, weight: .none)
                                .foregroundColor(Color.black)
                                .scaledPadding(top: viewStore.mode == .editing ? 4 : 20, leading: 25, bottom: 0, trailing: 25)

                            HStack {
                                ForEach(1..<8) {
                                    WeekButton(weekOfDay: $0, iter: viewStore.binding(
                                        get: \.iter,
                                        send: HabitFeature.Action.setIter
                                    ), onOff: viewStore.selectedHabit?.weekIter.contains($0) ?? false ? true : false)
                                }
                            }
                            .scaledPadding(top: 10, leading: 25, bottom: 0, trailing: 25)

                            Spacer(minLength: 8)

                            HStack {
                                Text("취소")
                                    .scaledText(size: 17, weight: .medium)
                                    .foregroundColor(Color.gray)
                                    .onTapGesture {
                                        viewStore.send(.setHabitTitle(""))
                                        viewStore.send(.setViewMode)
                                    }
                                Spacer()
                                Text("저장")
                                    .scaledText(size: 17, weight: .semibold)
                                    .foregroundColor(HabitColor.defaultGreen.color)
                                    .onTapGesture {
                                        if viewStore.mode == .editing {
                                            viewStore.send(.updateHabit(name: viewStore.habitTitle, iter: viewStore.iter, habit: viewStore.selectedHabit ?? Habit()))
                                        } else {
                                            viewStore.send(.addHabit(name: viewStore.habitTitle, iter: viewStore.iter))
                                        }
                                        viewStore.send(.setViewMode)
                                        viewStore.send(.setHabitTitle(""))

                                        statisticsStore.send(.updateTodoCount(add: true, numberOfIter: viewStore.iter.count))
                                        statisticsStore.send(.loadTodoStatistics)

                                        completionStore.send(.updateAllDoneContinuity(.add, isTodayHabit(viewStore.iter) ? true : false))
                                    }
                            }
                            .scaledPadding(top: 8, leading: 25, bottom: 16, trailing: 25)
                        }
                        .scaledFrame(width: .none, height: 280)
                    }
                }
            }
            .contentShape(Rectangle())
            .alert("삭제하시겠습니까?", isPresented: $showingDeleteAlert) {
                Button("확인", role: .destructive) {
                    guard let selectedHabit = viewStore.selectedHabit else { return }
                    viewStore.send(.edit(.deleteButtonPressed(selectedHabit)))
                    viewStore.send(.setViewMode)
                    viewStore.send(.setHabitTitle(""))
                    statisticsStore.send(.updateTodoCount(add: false, numberOfIter: selectedHabit.weekIter.count))
                    statisticsStore.send(.loadTodoStatistics)
                    completionStore.send(.updateAllDoneContinuity(.delete, isTodayHabit(Array(selectedHabit.weekIter))))
                }
                Button("취소", role: .cancel) { }
            } message: {
                Text("이 습관을 삭제해도 완료한 기록은 유지됩니다.")
            }
        }
    }

    func isTodayHabit(_ iter: [Int]) -> Bool {
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        return iter.contains(todayWeek)
    }
}
