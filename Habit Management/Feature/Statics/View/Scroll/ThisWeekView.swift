//
//  ThisWeekView.swift
//  Habit Management
//
//  Created by 한수진 on 5/25/25.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct ThisWeekView: View {
    let store: StoreOf<StaticsFeature>
    @EnvironmentObject var setting: Setting

//    @StateObject var staticVM = StaticVM.shared
    @Binding var frame_size: CGFloat
    var getColor: (String) -> Color
    
    var body: some View {
        WithPerceptionTracking {
            WithViewStore(store, observe: { $0 }) { viewStore in
                VStack(alignment: .center, spacing: 3*setting.WidthRatio) {
                    ForEach(Array(store.staticsData.thisWeek.enumerated()), id:\.offset){ index, date in
                        Text("\(date)")
                            .scaledFrame(width: frame_size, height: frame_size)
                            .overlay(
                                RoundedRectangle(cornerRadius: 3*setting.WidthRatio, style: .continuous)
                                    .fill(date == "" ? Color(hex: "#639F70"): getColor(date))
                                    .scaledFrame(width: frame_size, height: frame_size)
                            )
                    }
                    
                }
            }
        }
    }
}
