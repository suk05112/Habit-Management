//
//  HabitView.swift
//  Habit Management
//
//  Created by 한수진 on 5/20/25.
//

import SwiftUI
import CoreData
import RealmSwift
import Firebase
import ComposableArchitecture

struct HabitView: View {
    @Perception.Bindable var habitStore: StoreOf<HabitFeature>
    @Perception.Bindable var statisticsStore: StoreOf<StaticsFeature>

    var body: some View {
        WithPerceptionTracking {
            ZStack {
                VStack(spacing: 0) {
                    MainHeaderView(userName: $habitStore.userName,
                                   mainReport: $habitStore.mainReportText)
                    HabitGridView(store: statisticsStore) // 나중에 따로 추출해도 OK
                    MainToggleBar(
                        showAll: $habitStore.isShowingAllHabits,
                        hideCompleted: $habitStore.isHidingCompletedHabits,
                        toggleShowAll: {
                            habitStore.send(.toggleShowAll)
                        },
                        toggleHideCompleted: {
                            habitStore.send(.toggleHideCompleted)
                        }
                    )
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(habitStore.habitList) { habit in
                            ZStack {
                                //Edit View

                                //Item View
                                ItemView(
                                    store: habitStore,
                                    habit: habit
                                )
                            }
                        }
                    }
                    
                    MainAddButton {
                        habitStore.send(.selectItem(nil))
                        habitStore.send(.setEditMode(false))
                        habitStore.send(.setAddMode(true))
                    }
                    
                    Spacer()
                }
                .onAppear {
                    habitStore.send(.onAppear)
                }
                .toast(
                    message: "Current time:\n\(Date().formatted(date: .complete, time: .complete))",
                    isShowing: $habitStore.isToastVisible,
                    duration: Toast.long
                )
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
            }
        }
    }
}

struct MainHeaderView: View {
    @Binding var userName: String
    @Binding var mainReport: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color(hex: "#B8D9B9"))
                .edgesIgnoringSafeArea(.all)
                .scaledFrame(width: nil, height: 242)

            VStack(alignment: .leading) {
                Text("\(userName)님!\n\(mainReport)")
                    .scaledText(size: 25, weight: .semibold)
                    .scaledPadding(top: 10, leading: 15, bottom: 0, trailing: 0)
                    .lineLimit(nil)
                    .fixedSize(horizontal: true, vertical: true)
            }
        }
    }
}

struct MainToggleBar: View {
    @Binding var showAll: Bool
    @Binding var hideCompleted: Bool
    var toggleShowAll: () -> Void
    var toggleHideCompleted: () -> Void

    var body: some View {
        HStack {
            Text(showAll ? "예정된 습관만 보기" : "습관 모두 보기")
                .onTapGesture {
                    toggleShowAll()
                }
            Spacer()
            Text(hideCompleted ? "완료된 항목 보이기" : "완료된 항목 숨기기")
                .onTapGesture {
                    toggleHideCompleted()
                }
        }
        .scaledPadding(top: 0, leading: 15, bottom: 0, trailing: 15)
    }
}

struct MainAddButton: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            onTap()
        }) {
            Image(systemName: "plus")
                .foregroundColor(.black)
        }
        .scaledPadding(top: 5, leading: 0, bottom: 5, trailing: 0)
    }
}
