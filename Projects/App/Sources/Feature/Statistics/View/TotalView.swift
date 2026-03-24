//
//  TotalView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/19.
//

import SwiftUI
import ComposableArchitecture

struct TotalView: View {
    let staticCase: Total
    let store: StoreOf<StatisticsFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            let count = viewStore.totalCounts[staticCase] ?? 0
            let statisticsStr = staticCase.localizedTitle
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .scaledFrame(width: 85, height: 57)
                    .shadow(radius: 1)
                VStack{
                    Text("\(count)")
                        .scaledText(size: 23, weight: .thin)
                    Text("\(statisticsStr)")
                        .scaledText(size: 12, weight: .regular)
                    
                }
            }
        }
    }
}
