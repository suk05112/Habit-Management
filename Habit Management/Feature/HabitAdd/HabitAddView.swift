//
//  HabitAddView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/31.
//

import SwiftUI
import RealmSwift
import ComposableArchitecture

struct HabitAddView: View {
    let habitStore: StoreOf<HabitFeature>
    let habitAddStore: StoreOf<HabitAddFeature>
    
    let statisticsStore = Store(initialState: StatisticsFeature.State()) { StatisticsFeature() }
    let completionStore = Store(initialState: CompletionFeature.State()) { CompletionFeature() }
    
    @ObservedObject var textfield = TextLimiter()
    
    init(habitStore: StoreOf<HabitFeature>) {
        self.habitStore = habitStore
        self.habitAddStore = habitStore.scope(state: \.add, action: \.add)
    }
    
    var body: some View {
        WithViewStore(habitStore, observe: { $0 }) { viewStore in
            VStack(alignment: .center) {
                HeaderView()
                //                    HStack {
                //                        cancelButton()
                //                        Spacer()
                //
                //                        Text("저장")
                //                            .foregroundStyle(HabitColor.blackGreen.color)
                //                            .scaledText(size: 18, weight: .bold)
                //                            .onTapGesture {
                //                                if viewStore.mode == .editing {
                //                                    viewStore.send(.updateHabit(name: viewStore.habitTitle, iter: viewStore.iter, habit: viewStore.selectedHabit ?? Habit()))
                //                                } else {
                //                                    viewStore.send(.addHabit(name: viewStore.habitTitle, iter: viewStore.iter))
                //                                }
                //                                viewStore.send(.setViewMode)
                //                                viewStore.send(.setHabitTitle(""))
                //
                //                                statisticsStore.send(.setnumOfToDo(add: true, numOfIter: viewStore.iter.count))
                //                                statisticsStore.send(.getnumOfToDo)
                //
                //                                completionStore.send(.updateAllDoneContinuity(.add, isTodayHabit(viewStore.iter) ? true : false))
                //                            }
                //                    }
                //                    .scaledPadding(top: 20, leading: 20, bottom: 12, trailing: 20)
                
                TextFieldView()
                
                //                    TextField("제목을 입력하세요", text: viewStore.binding(get: \.habitTitle, send: {
                //                        .setHabitTitle($0) }))
                //                    .padding(12)
                //                    .overlay(
                //                        RoundedRectangle(cornerRadius: 8)
                //                            .stroke(HabitColor.defaultGray.color, lineWidth: 1)
                //                    )
                //                    .accentColor(HabitColor.mediumGreen.color)
                //                    .scaledText(size: 23, weight: .none)
                //                    .foregroundColor(Color.black)
                //                    .scaledPadding(top: 0, leading: 20, bottom: 0, trailing: 20)
                //                    .focused($isFocused)
                
                WeekDayView(habitStore: habitStore)
                Spacer()
            }
            .ignoresSafeArea()
        }
    }
    
    func isTodayHabit(_ iter: [Int]) -> Bool {
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        return iter.contains(todayWeek)
    }
}
