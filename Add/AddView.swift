//
//  Add.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/31.
//

import Foundation
import SwiftUI
import UIKit
import RealmSwift
import ComposableArchitecture

public struct AddView: View{
    @Perception.Bindable var store: StoreOf<HabitFeature>
    let completionStore: StoreOf<CompletionFeature>

    public var body: some View {
        WithPerceptionTracking {
            if store.isShowingAdd {
                ZStack{
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.vertical)
                    VStack{
                        HStack{}
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .scaledFrame(width: .none, height: 250)
                                .scaledPadding(top: 0, leading: 5, bottom: 0, trailing: 5)
                                .foregroundColor(Color.white)
                            
                            VStack(alignment: .center){
                                HStack{
                                    Text("취소")
                                        .onTapGesture {
                                            store.send(.setHabitTitle(""))
                                            store.send(.setEditMode(false))
                                        }
                                    Spacer()
                                    
                                    Text("저장")
                                        .onTapGesture {
                                            store.send(.setAddMode(false))
                                            if !store.isEditingHabit {
                                                store.send(.addHabit(name: store.habitTitle, iter: store.iter))
                                            }
                                            else{
                                                store.send(.updateHabit(name: store.habitTitle, iter: store.iter, habit: store.selectedHabit ?? Habit()))
                                                store.send(.setEditMode(false))
                                            }
                                            store.send(.setHabitTitle(""))
                                            StaticVM.shared.setnumOfToDoPerDay()
                                            StaticVM.shared.setnumOfToDoPerWeek2(add: true, numOfIter: store.iter.count)
                                            StaticVM.shared.setnumOfToDoPerMonth(add: true, numOfIter: store.iter.count)
                                            completionStore.send(.updateAllDoneContinuity(.add, isTodayHabit() ? true : false))
                                        }
                                }
                                .scaledPadding(top: 15, leading: 25, bottom: 10, trailing: 25)
                                
                                TextField("제목을 입력하세요", text: $store.habitTitle)
                                    .textFieldStyle(.roundedBorder)
                                    .scaledText(size: 25, weight: .none)
                                    .foregroundColor(Color.black)
                                    .scaledPadding(top: 0, leading: 25, bottom: 0, trailing: 25)
                                
                                HStack{
                                    ForEach(1..<8){
                                        WeekButton(weekOfDay: $0, iter: $store.iter, OnOff:  Array(store.selectedHabit!.weekIter).contains($0) ? true : false)
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

    }
    
    func isTodayHabit() -> Bool{
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        
        if store.iter.contains(todayWeek){
            return true
        }
        else{
            return false
        }
    }

}

