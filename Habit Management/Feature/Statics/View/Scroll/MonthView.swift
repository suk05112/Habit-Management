//
//  MonthView.swift
//  Habit Management
//
//  Created by 한수진 on 5/25/25.
//

import SwiftUI
import ComposableArchitecture

struct MonthView: View {
    let store: StoreOf<StaticsFeature>
    
    @EnvironmentObject var setting: Setting
    @Binding var frame_size: CGFloat
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack(alignment: .center, spacing: 3 * setting.WidthRatio) {
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
