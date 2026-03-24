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
    @State private var showTitleRequiredError = false
    @State private var showWeekdayRequiredError = false

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
                            .scaledFrame(width: .none, height: 320)
                            .scaledPadding(top: 0, leading: 5, bottom: 0, trailing: 5)
                            .foregroundColor(Color.white)

                        VStack(alignment: .center, spacing: 0) {
                            if viewStore.mode == .editing {
                                HStack {
                                    Spacer()
                                    Button(L10n.tr("common.delete")) {
                                        showingDeleteAlert = true
                                    }
                                    .foregroundColor(.red)
                                    .scaledText(size: 15, weight: .semibold)
                                }
                                .scaledPadding(top: 12, leading: 25, bottom: 4, trailing: 20)
                            }

                            TextField(
                                L10n.tr("add.title_placeholder"),
                                text: Binding(
                                    get: { viewStore.habitTitle },
                                    set: { viewStore.send(.setHabitTitle($0)); showTitleRequiredError = false }
                                )
                            )
                                .textFieldStyle(.roundedBorder)
                                .scaledText(size: 25, weight: .none)
                                .foregroundColor(Color.black)
                                .scaledPadding(top: viewStore.mode == .editing ? 4 : 20, leading: 25, bottom: 0, trailing: 25)

                            if showTitleRequiredError {
                                Text(L10n.tr("add.title_required"))
                                    .foregroundColor(.red)
                                    .scaledText(size: 14, weight: .medium)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .scaledPadding(top: 6, leading: 28, bottom: 0, trailing: 25)
                            }

                            HStack {
                                ForEach(1..<8) {
                                    WeekButton(
                                        weekOfDay: $0,
                                        iter: Binding(
                                            get: { viewStore.iter },
                                            set: { newIter in
                                                viewStore.send(.setIter(newIter))
                                                if !newIter.isEmpty {
                                                    showWeekdayRequiredError = false
                                                }
                                            }
                                        ),
                                        onOff: viewStore.selectedHabit?.weekIter.contains($0) ?? false ? true : false
                                    )
                                }
                            }
                            .scaledPadding(top: 10, leading: 25, bottom: 0, trailing: 25)

                            if showWeekdayRequiredError {
                                Text(L10n.tr("add.weekday_required"))
                                    .foregroundColor(.red)
                                    .scaledText(size: 14, weight: .medium)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .scaledPadding(top: 6, leading: 28, bottom: 0, trailing: 25)
                            }

                            Spacer(minLength: 8)

                            HStack {
                                Text(L10n.tr("common.cancel"))
                                    .scaledText(size: 17, weight: .medium)
                                    .foregroundColor(Color.gray)
                                    .onTapGesture {
                                        showTitleRequiredError = false
                                        showWeekdayRequiredError = false
                                        viewStore.send(.setHabitTitle(""))
                                        viewStore.send(.setViewMode)
                                    }
                                Spacer()
                                Text(L10n.tr("common.save"))
                                    .scaledText(size: 17, weight: .semibold)
                                    .foregroundColor(HabitColor.defaultGreen.color)
                                    .onTapGesture {
                                        let trimmed = viewStore.habitTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                                        guard !trimmed.isEmpty else {
                                            showTitleRequiredError = true
                                            showWeekdayRequiredError = false
                                            return
                                        }
                                        showTitleRequiredError = false

                                        guard !viewStore.iter.isEmpty else {
                                            showWeekdayRequiredError = true
                                            return
                                        }
                                        showWeekdayRequiredError = false

                                        if viewStore.mode == .editing {
                                            viewStore.send(.updateHabit(name: trimmed, iter: viewStore.iter, habit: viewStore.selectedHabit ?? Habit()))
                                        } else {
                                            viewStore.send(.addHabit(name: trimmed, iter: viewStore.iter))
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
                        .scaledFrame(width: .none, height: 320)
                    }
                }
            }
            .contentShape(Rectangle())
            .alert(L10n.tr("add.alert.title"), isPresented: $showingDeleteAlert) {
                Button(L10n.tr("common.confirm"), role: .destructive) {
                    guard let selectedHabit = viewStore.selectedHabit else { return }
                    viewStore.send(.edit(.deleteButtonPressed(selectedHabit)))
                    viewStore.send(.setViewMode)
                    viewStore.send(.setHabitTitle(""))
                    statisticsStore.send(.updateTodoCount(add: false, numberOfIter: selectedHabit.weekIter.count))
                    statisticsStore.send(.loadTodoStatistics)
                    completionStore.send(.updateAllDoneContinuity(.delete, isTodayHabit(Array(selectedHabit.weekIter))))
                }
                Button(L10n.tr("common.cancel"), role: .cancel) { }
            } message: {
                Text(L10n.tr("add.alert.message"))
            }
        }
    }

    func isTodayHabit(_ iter: [Int]) -> Bool {
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        return iter.contains(todayWeek)
    }
}
