//
//  ThisWeekView.swift
//  Habit Management
//
//  Created by 한수진 on 5/25/25.
//

import SwiftUI
import ComposableArchitecture

struct ThisWeekView: View {
    private let store: StoreOf<StatisticsFeature>
    
    private var ratioSpacing: CGFloat
    private var frame_size: CGFloat
    private var getColor: (String) -> Color
    
    init(store: StoreOf<StatisticsFeature>, ratioSpacing: CGFloat, frame_size: CGFloat, getColor: @escaping (String) -> Color) {
        self.store = store
        self.ratioSpacing = ratioSpacing
        self.frame_size = frame_size
        self.getColor = getColor
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .center, spacing: ratioSpacing) {
                Text("Test")
//                ForEach(Array(viewStore.staticsData.thisWeek.enumerated()), id:\.offset) { index, date in
//                    Text("\(date)")
//                        .scaledFrame(width: frame_size, height: frame_size)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: ratioSpacing, style: .continuous)
//                                .fill(date == "" ? HabitColor.defaultGreen.color : getColor(date))
//                                .scaledFrame(width: frame_size, height: frame_size)
//                        )
//                }
            }
        }
    }
}
