//
//  HabitToggleView.swift
//  Habit Management
//
//  Created by 서충원 on 6/15/25.
//

import SwiftUI
import ComposableArchitecture

struct HabitToggleView: View {
    let habitToggleStore: StoreOf<HabitToggleFeature>
    
    init(habitStore: StoreOf<HabitFeature>) {
        self.habitToggleStore = habitStore.scope(state: \.toggle, action: \.toggle)
    }
    
    var body: some View {
        WithViewStore(habitToggleStore, observe: { $0 }) { viewStore in
            HStack {
                Button {
                    viewStore.send(.showAllButtonPressed)
                } label: {
                    showAllLabel(title: viewStore.labelTitle.showAll)
                }
                
                Spacer()
                
                Button {
                    viewStore.send(.hideCompletedButtonPressed)
                } label: {
                    hideCompletedLabel(title: viewStore.labelTitle.hideCompleted)
                }
            }
            .scaledPadding(top: 0, leading: 16, bottom: 0, trailing: 16)
        }
    }
}

// MARK: - UI Components
extension HabitToggleView {
    private func showAllLabel(title: String) -> some View {
        Text(title)
            .scaledText(size: 16, weight: .bold)
            .foregroundColor(Color.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(HabitColor.mediumGreen.color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func hideCompletedLabel(title: String) -> some View {
        Text(title)
            .scaledText(size: 16, weight: .bold)
            .foregroundColor(Color.gray.opacity(0.6))
    }
}
