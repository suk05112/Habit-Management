//
//  AddHabitView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/31.
//

import SwiftUI
import RealmSwift
import ComposableArchitecture

struct AddHabitView: View {
    let habitStore: StoreOf<HabitFeature>
    
    let statisticsStore: StoreOf<StatisticsFeature> = Store(initialState: StatisticsFeature.State(), reducer: { StatisticsFeature() })
    let completionStore: StoreOf<CompletionFeature> = Store(initialState: CompletionFeature.State(), reducer: { CompletionFeature() })
    
    @ObservedObject var textfield = TextLimiter()
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        WithViewStore(habitStore, observe: { $0 }) { viewStore in
            background {
                VStack(alignment: .center) {
                    HStack {
                        cancelButton()
                        Spacer()
                        
                        Text("저장")
                            .foregroundStyle(HabitColor.blackGreen.color)
                            .scaledText(size: 18, weight: .bold)
                            .onTapGesture {
                                if viewStore.mode == .editing {
                                    viewStore.send(.updateHabit(name: viewStore.habitTitle, iter: viewStore.iter, habit: viewStore.selectedHabit ?? Habit()))
                                } else {
                                    viewStore.send(.addHabit(name: viewStore.habitTitle, iter: viewStore.iter))
                                }
                                viewStore.send(.setViewMode)
                                viewStore.send(.setHabitTitle(""))
                                
                                statisticsStore.send(.setnumOfToDo(add: true, numOfIter: viewStore.iter.count))
                                statisticsStore.send(.getnumOfToDo)
                                
                                completionStore.send(.updateAllDoneContinuity(.add, isTodayHabit(viewStore.iter) ? true : false))
                            }
                    }
                    .scaledPadding(top: 20, leading: 20, bottom: 12, trailing: 20)
                    
                    TextField("제목을 입력하세요", text: viewStore.binding(get: \.habitTitle, send: {
                        .setHabitTitle($0) }))
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(HabitColor.defaultGray.color, lineWidth: 1)
                    )
                    .accentColor(HabitColor.mediumGreen.color)
                    .scaledText(size: 23, weight: .none)
                    .foregroundColor(Color.black)
                    .scaledPadding(top: 0, leading: 20, bottom: 0, trailing: 20)
                    .focused($isFocused)
                    
                    HStack() {
                        ForEach(1...7, id: \.self) { index in
                            WeekDayButton(weekOfDay: index, iter: viewStore.binding(
                                get: \.iter,
                                send: HabitFeature.Action.setIter
                            ), isSelected: viewStore.selectedHabit?.weekIter.contains(index) ?? false ? true : false)
                            if index != 7 {
                                Spacer()
                            }
                        }
                    }
                    .scaledPadding(top: 8, leading: 20, bottom: 24, trailing: 20)
                }
                .background {
                    Rectangle()
                        .fill(Color.white)
                        .clipShape(
                            RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                        )
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isFocused = true
                }
            }
        }
    }
    
    func isTodayHabit(_ iter: [Int]) -> Bool {
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        return iter.contains(todayWeek)
    }
}

// MARK: - UI Components
extension AddHabitView {
    @ViewBuilder
    private func background<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.vertical)
                .onTapGesture {
                    isFocused = false
//                    viewStore.send(.setHabitTitle(""))
//                    viewStore.send(.setViewMode)
                }
            
            content()
        }
    }
    
    private func cancelButton() -> some View {
        Button {

        } label: {
            Text("취소")
                .foregroundStyle(HabitColor.blackGreen.color)
                .scaledText(size: 18, weight: .regular)
        }
    }
}





#Preview {
    let habitStore = Store(initialState: HabitFeature.State()) {
        HabitFeature()
    }
    
    let setting: Setting = Setting()
    
    AddHabitView(habitStore: habitStore)
        .environmentObject(setting)
}
