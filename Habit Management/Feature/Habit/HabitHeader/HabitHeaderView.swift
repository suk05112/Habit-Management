//
//  HabitHeaderView.swift
//  Habit Management
//
//  Created by 서충원 on 6/9/25.
//

import SwiftUI
import ComposableArchitecture

struct HabitHeaderView: View {
    let store: StoreOf<HabitHeaderFeature>
    
    init(store: StoreOf<HabitHeaderFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(viewStore.userName)님!")
                        .habitHeaderStyle()
                    Text("\(viewStore.mainReportText)")
                        .habitHeaderStyle()
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

extension Text {
    func habitHeaderStyle() -> some View {
        self.scaledText(size: 25, weight: .semibold)
    }
}
