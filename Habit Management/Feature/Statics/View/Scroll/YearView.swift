//
//  YearView.swift
//  Habit Management
//
//  Created by 한수진 on 5/25/25.
//

import SwiftUI
import ComposableArchitecture

struct YearView: View {
    let store: StoreOf<StaticsFeature>
    
    @EnvironmentObject var setting: Setting
    @Binding var frame_size: CGFloat
    
    var getColor: (String) -> Color
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ForEach(viewStore.dayArray.indices, id:\.self) { i in
                VStack(alignment: .center, spacing: 3 * setting.WidthRatio) {
                    ForEach(Array(viewStore.dayArray[i].enumerated()), id:\.offset) {index, j in
                        Text("\(j)")
                            .scaledFrame(width: frame_size, height: frame_size)
                            .overlay(
                                RoundedRectangle(cornerRadius: 3 * setting.WidthRatio, style: .continuous)
                                    .fill(j == "" ? Color(hex: "#639F70"): getColor(j))
                                    .scaledFrame(width: frame_size, height: frame_size)
                            )
                    }
                }
            }
        }
    }
}
