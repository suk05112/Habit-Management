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
    private var frameSize: CGFloat
    private var getColor: (String) -> Color

    init(
        store: StoreOf<StatisticsFeature>,
        ratioSpacing: CGFloat,
        frameSize: CGFloat,
        getColor: @escaping (String) -> Color
    ) {
        self.store = store
        self.ratioSpacing = ratioSpacing
        self.frameSize = frameSize
        self.getColor = getColor
    }

    var body: some View {
        WithViewStore(store, observe: { $0 }, content: { viewStore in
            VStack(alignment: .center, spacing: ratioSpacing) {
                ForEach(
                    Array(viewStore.statisticsData.thisWeek.enumerated()),
                    id: \.offset
                ) { _, date in
                    Text("\(date)")
                        .scaledFrame(width: frameSize, height: frameSize)
                        .overlay(
                            RoundedRectangle(cornerRadius: ratioSpacing, style: .continuous)
                                .fill(date == "" ? HabitColor.defaultGreen.color : getColor(date))
                                .scaledFrame(width: frameSize, height: frameSize)
                        )
                }
            }
        })
    }
}
