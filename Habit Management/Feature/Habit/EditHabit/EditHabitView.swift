//
//  EditView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/20.
//

import SwiftUI
import ComposableArchitecture

struct EditHabitView: View {
    private let editStore: StoreOf<EditHabitFeature>
    private let statisticsStore: StoreOf<StatisticsFeature>
    private let habit: Habit
    @Binding var offset: CGFloat
    
    init(habitStore: StoreOf<HabitFeature>,
         statisticsStore: StoreOf<StatisticsFeature>,
         habit: Habit,
         offset: Binding<CGFloat>) {
        self.editStore = habitStore.scope(state: \.edit, action: \.edit)
        self.statisticsStore = statisticsStore
        self.habit = habit
        self._offset = offset
    }
    
    @State private var showingAlert = false
    
    var body: some View {
        WithViewStore(statisticsStore, observe: { $0 }) { statisticsStore in
            WithViewStore(editStore, observe: { $0 }) { editStore in
                HStack {
                    if offset > 0, !habit.isInvalidated {
                        Button(action: {
                            self.showingAlert.toggle()
                            withAnimation(.easeOut) {
                                habit.offset = 0
                            }
                        }) {
                            Image(systemName: "trash")
                                .font(.title)
                                .foregroundColor(.white)
                                .scaledFrame(width: 50, height: 80)
                                .background(Color.red)
                                .cornerRadius(12)
                        }
                        .alert("삭제하시겠습니까?", isPresented: $showingAlert) {
                            Button("확인", role: .destructive, action: {
                                editStore.send(.deleteButtonPressed(habit))
                                statisticsStore.send(.updateTodoCount(add: false, numberOfIter: habit.weekIter.count))
                                statisticsStore.send(.loadTodoStatistics)
                            })
                            
                            Button("취소", role: .cancel) { }
                        } message: {
                            Text("이 습관을 삭제해도 완료한 기록은 유지됩니다.")
                        }
                        .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: -5)
                        
                        Button(action: {
                            editStore.send(.editButtonPressed(habit))
                            withAnimation(.easeOut) {
                                habit.offset = 0
                                offset = 0
                            }
                        }) {
                            Image(systemName: "pencil")
                                .font(.title)
                                .foregroundColor(.white)
                                .scaledFrame(width: 50, height: 80)
                                .background(Color(hex: "#92BCA3"))
                                .cornerRadius(12)
                        }
                        
                        Spacer()
                    } else {
                        Spacer()
                        
                        if !habit.isInvalidated {
                            Button(action: {
                                statisticsStore.send(.addOrUpdate)
                                editStore.send(.completeButtonPressed(habit))
                                withAnimation(.easeOut) {
                                    habit.offset = 0
                                    offset = 0
                                }
                            }) {
                                Image(systemName: "checkmark")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .scaledFrame(width: 50, height: 80)
                                    .background(habit.today() ? Color(hex: "#92BCA3") : Color(hex: "#D4DED8"))
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
            }
        }
        .scaledPadding(top: 0, leading: 16, bottom: 0, trailing: 16)
    }
}

