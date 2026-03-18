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
    private let statisticsStore: StoreOf<StatisticsFeature>
    private let completionStore: StoreOf<CompletionFeature>
    
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
            ScrollView(.vertical, showsIndicators: false) {
                Spacer().frame(height: 8)
                ForEach(viewStore.habitList, id: \.id) { habit in
                        HabitItemView(
                            habitStore: habitStore,
                            habit: habit,
                            statisticsStore: statisticsStore,
                            completionStore: completionStore
                        )
                }
                Spacer().frame(height: 8)
            }
        }
    }
}
