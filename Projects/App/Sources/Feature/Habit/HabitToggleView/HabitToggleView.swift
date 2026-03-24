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
            HStack(spacing: 8) {
                showAllButton(title: viewStore.labelTitle.showAll) {
                    viewStore.send(.showAllButtonPressed)
                }
                .frame(maxWidth: .infinity)

                hideCompletedButton(title: viewStore.labelTitle.hideCompleted) {
                    viewStore.send(.hideCompletedButtonPressed)
                }
                .frame(maxWidth: .infinity)

                addHabitButton {
                    viewStore.send(.addHabitButtonPressed)
//                    viewStore.send(.selectItem(nil))
//                    viewStore.send(.setEditMode(false))
//                    viewStore.send(.setAddMode(true))
                }
            }
            .scaledPadding(top: 12, leading: 16, bottom: 8, trailing: 16)
        }
    }
}

// MARK: - UI Components
extension HabitToggleView {
    private func showAllButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .scaledText(size: 16, weight: .bold)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, minHeight: 36)
                .background(HabitColor.mediumGreen.color)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private func hideCompletedButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .scaledText(size: 16, weight: .bold)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, minHeight: 36)
                .background(HabitColor.mediumGreen.color)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
    
    private func addHabitButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "plus")
                .foregroundColor(Color.white)
                .padding(4)
                .background(Circle().fill(HabitColor.defaultGreen.color).frame(width: 32, height: 32))
                .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 4)
        }
    }
}
