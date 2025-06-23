//
//  HabitHeaderView.swift
//  Habit Management
//
//  Created by 서충원 on 6/9/25.
//

import SwiftUI
import ComposableArchitecture

struct HabitHeaderView: View {
    private let habitHeaderStore: StoreOf<HabitHeaderFeature>
    
    init(habitStore: StoreOf<HabitFeature>) {
        self.habitHeaderStore = habitStore.scope(state: \.header, action: \.header)
    }
    
    var body: some View {
        WithViewStore(habitHeaderStore, observe: { $0 }) { viewStore in
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(viewStore.userName)님!")
                        .foregroundStyle(HabitColor.blackGreen.color)
                        .scaledText(size: 24, weight: .bold)
                    Text("\(viewStore.mainReportText)")
                        .foregroundStyle(HabitColor.blackGreen.color)
                        .scaledText(size: 24, weight: .regular)
                }
                Spacer()
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
