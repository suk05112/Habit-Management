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
    
    @EnvironmentObject var setting: Setting
    
    init(store: StoreOf<CalendarMonthFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack(alignment: .center, spacing: setting.ratioSpacing) {
                ForEach(viewStore.monthItemArray, id: \.id) { item in
                    monthLabel(item.month)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

// MARK: - UI Components
extension CalendarMonthView {
    private func monthLabel(_ month: String) -> some View {
        Text(month)
            .foregroundColor(Color.white)
            .scaledText(size: 10, weight: .bold)
            .scaledFrame(width: setting.frameSize, height: setting.frameSize)
    }
}
