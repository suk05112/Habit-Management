//
//  HabitHeaderView.swift
//  Habit Management
//
//  Created by 서충원 on 6/9/25.
//

import SwiftUI
import ComposableArchitecture

private struct HabitHeaderBar: Equatable {
    var userName: String
    var mainReportText: String
}

struct HabitHeaderView: View {
    private let habitStore: StoreOf<HabitFeature>

    init(habitStore: StoreOf<HabitFeature>) {
        self.habitStore = habitStore
    }

    var body: some View {
        WithViewStore(habitStore, observe: {
            HabitHeaderBar(userName: $0.userName, mainReportText: $0.mainReportText)
        }) { viewStore in
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(L10n.tr("habit.greeting", viewStore.userName))
                        .foregroundStyle(Color(hex: "2E4A2B"))
                        .scaledText(size: 24, weight: .bold)
                    Text(viewStore.mainReportText)
                        .foregroundStyle(Color(hex: "2E4A2B"))
                        .scaledText(size: 24, weight: .regular)
                }
                Spacer()
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .onAppear {
                viewStore.send(.header(.onAppear))
            }
        }
    }
}
