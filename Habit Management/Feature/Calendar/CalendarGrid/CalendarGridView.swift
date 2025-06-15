//
//  CalendarGridView.swift
//  Habit Management
//
//  Created by 한수진 on 5/25/25.
//

import SwiftUI
import ComposableArchitecture

struct CalendarGridView: View {
    private let store: StoreOf<CalendarGridFeature>
    
    private var ratioSpacing: CGFloat
    private var frame_size: CGFloat
    private var getColor: (String) -> Color
    private var aa: String = ""
    
    init(store: StoreOf<CalendarGridFeature>, ratioSpacing: CGFloat, frame_size: CGFloat, getColor: @escaping (String) -> Color) {
        self.store = store
        self.ratioSpacing = ratioSpacing
        self.frame_size = frame_size
        self.getColor = getColor
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ForEach(viewStore.dayArray.indices, id:\.self) { i in
                VStack(alignment: .center, spacing: ratioSpacing) {
                    ForEach(Array(viewStore.dayArray[i].enumerated()), id:\.offset) {index, j in
                        RoundedRectangle(cornerRadius: ratioSpacing, style: .continuous)
                            .fill(j == "" ? Color(hex: "#639F70"): getColor(j))
                            .scaledFrame(width: frame_size, height: frame_size)
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
