//
//  Add.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/31.
//

import SwiftUI
import UIKit
import RealmSwift
import ComposableArchitecture

struct AddView: View {
    let habitStore: StoreOf<HabitFeature>
    
    let statisticsStore: StoreOf<StatisticsFeature> = Store(initialState: StatisticsFeature.State(), reducer: { StatisticsFeature() })
    let completionStore: StoreOf<CompletionFeature> = Store(initialState: CompletionFeature.State(), reducer: { CompletionFeature() })
    
    @ObservedObject var textfield = TextLimiter()
    
    var body: some View {
        WithViewStore(habitStore, observe: { $0 }) { viewStore in
            ZStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.vertical)
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .scaledFrame(width: .none, height: 250)
                            .scaledPadding(top: 0, leading: 5, bottom: 0, trailing: 5)
                            .foregroundColor(Color.white)
                        
                        VStack(alignment: .center) {
                            HStack{
                                Text("취소")
                                    .onTapGesture {
                                        viewStore.send(.setHabitTitle(""))
                                        viewStore.send(.setEditMode(false))
                                        viewStore.send(.setAddMode(false))
                                    }
                                Spacer()
                                
                                Text("저장")
                                    .onTapGesture {
                                        viewStore.send(.setAddMode(false))
                                        if !viewStore.isEditingHabit {
                                            viewStore.send(.addHabit(name: viewStore.habitTitle, iter: viewStore.iter))
                                        }
                                        else{
                                            viewStore.send(.updateHabit(name: viewStore.habitTitle, iter: viewStore.iter, habit: viewStore.selectedHabit ?? Habit()))
                                            viewStore.send(.setEditMode(false))
                                        }
                                        viewStore.send(.setHabitTitle(""))
                                        
                                        statisticsStore.send(.setnumOfToDo(add: true, numOfIter: viewStore.iter.count))
                                        statisticsStore.send(.getnumOfToDo)
                                        
                                        completionStore.send(.updateAllDoneContinuity(.add, isTodayHabit(viewStore.iter) ? true : false))
                                        
                                    }
                            }
                            .scaledPadding(top: 15, leading: 25, bottom: 10, trailing: 25)
                            
                            TextField("제목을 입력하세요", text: viewStore.binding(get: \.habitTitle, send: { .setHabitTitle($0) }))
                                .textFieldStyle(.roundedBorder)
                                .scaledText(size: 25, weight: .none)
                                .foregroundColor(Color.black)
                                .scaledPadding(top: 0, leading: 25, bottom: 0, trailing: 25)
                            
                            HStack{
                                ForEach(1..<8){
                                    WeekButton(weekOfDay: $0, iter: viewStore.binding(
                                        get: \.iter,
                                        send: HabitFeature.Action.setIter
                                    ), OnOff: viewStore.selectedHabit?.weekIter.contains($0) ?? false ? true : false)
                                }
                            }
                            .scaledPadding(top: 10, leading: 25, bottom: 10, trailing: 25)
                            Spacer()
                            
                        }
                        .scaledFrame(width: .none, height: 250)
                    }
                }
            }
            .contentShape(Rectangle())
        }
    }
    
    func isTodayHabit(_ iter: [Int]) -> Bool {
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        return iter.contains(todayWeek)
    }
}

