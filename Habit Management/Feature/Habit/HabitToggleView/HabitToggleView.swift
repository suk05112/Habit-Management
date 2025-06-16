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
                HabitToggleButton(
                    title: viewStore.labelTitle.showAll,
                    style: .filled,
                    action: { viewStore.send(.showAllButtonPressed) }
                )
                
                Spacer()
                
                HabitToggleButton(
                    title: viewStore.labelTitle.hideCompleted,
                    style: .plain,
                    action: { viewStore.send(.hideCompletedButtonPressed) }
                )
            }
            .scaledPadding(top: 0, leading: 16, bottom: 0, trailing: 16)
        }
    }
}

// MARK: - UI Components
enum HabitToggleButtonStyle {
    case filled
    case plain
}

struct HabitToggleButton: View {
    let title: String
    let style: HabitToggleButtonStyle
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .scaledText(size: 16, weight: .bold)
                .foregroundColor(foregroundColor)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(background)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .filled: return .white
        case .plain: return .gray.opacity(0.6)
        }
    }
    
    private var background: some View {
        switch style {
        case .filled: return HabitColor.mediumGreen.color
        case .plain: return Color.clear
        }
    }
}
