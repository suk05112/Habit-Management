//
//  HabitScrollView.swift
//  Habit Management
//
//  Created by 서충원 on 6/17/25.
//

import SwiftUI
import ComposableArchitecture

struct HabitScrollView: View {
    private let habitStore: StoreOf<HabitFeature>
    
    init(habitStore: StoreOf<HabitFeature>) {
        self.habitStore = habitStore
    }
    
    var body: some View {
        WithViewStore(habitStore, observe: { $0 }) { viewStore in
            ScrollView(.vertical, showsIndicators: false) {
                Spacer().frame(height: 8)
                ForEach(viewStore.habitList) { habit in
                    HabitItemView(habitStore: habitStore, habit: habit)
                }
            }
        }
    }
}
