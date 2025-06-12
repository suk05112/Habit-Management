//
//  GridMonthHeaderView.swift
//  Habit Management
//
//  Created by 한수진 on 5/25/25.
//

import SwiftUI
import ComposableArchitecture

struct GridMonthHeaderView: View {
    private let store: StoreOf<StatisticsFeature>
    
    private var ratioSpacing: CGFloat
    private var frame_size: CGFloat
    
    init(store: StoreOf<StatisticsFeature>, ratioSpacing: CGFloat, frame_size: CGFloat) {
        self.store = store
        self.ratioSpacing = ratioSpacing
        self.frame_size = frame_size
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack(alignment: .center, spacing: ratioSpacing) {
                ForEach(Array(viewStore.monthArray.enumerated()), id: \.offset) { index, item in
                    Text(item)
                        .scaledText(size: 10, weight: .bold)
                        .foregroundColor(Color.white)
                        .scaledFrame(width: frame_size, height: frame_size)
                }
            }
        }
    }
}
