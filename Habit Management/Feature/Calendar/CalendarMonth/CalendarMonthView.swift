//
//  CalendarMonthView.swift
//  Habit Management
//
//  Created by 한수진 on 5/25/25.
//

import SwiftUI
import ComposableArchitecture

struct CalendarMonthView: View {
    private let store: StoreOf<CalendarMonthFeature>
    
    private var ratioSpacing: CGFloat
    private var frame_size: CGFloat
    
    init(store: StoreOf<CalendarMonthFeature>, ratioSpacing: CGFloat, frame_size: CGFloat) {
        self.store = store
        self.ratioSpacing = ratioSpacing
        self.frame_size = frame_size
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack(alignment: .center, spacing: ratioSpacing) {
                ForEach(viewStore.monthArray, id: \.self) { month in
                    monthLabel(month)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

extension CalendarMonthView {
    private func monthLabel(_ month: String) -> some View {
        Text(month)
            .foregroundColor(Color.white)
            .scaledText(size: 10, weight: .bold)
            .scaledFrame(width: frame_size, height: frame_size)
    }
}
