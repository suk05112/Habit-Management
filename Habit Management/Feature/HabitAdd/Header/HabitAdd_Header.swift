//
//  HabitAdd_Header.swift
//  Habit Management
//
//  Created by 서충원 on 6/24/25.
//

import SwiftUI

extension HabitAddView {
    struct HeaderView: View {
        var body: some View {
            HStack {
                cancelButton()
                Spacer()
                saveButton()
            }
            .scaledPadding(top: 20, leading: 20, bottom: 12, trailing: 20)
        }
        
        private func cancelButton() -> some View {
            Button {
                // Action
            } label: {
                Text("취소")
                    .foregroundStyle(.gray.opacity(0.6))
                    .scaledText(size: 18, weight: .regular)
            }
        }
        
        private func saveButton() -> some View {
            Button {
                // Action
            } label: {
                Text("저장")
                    .foregroundStyle(HabitColor.defaultGreen.color)
                    .scaledText(size: 18, weight: .semibold)
            }
        }
    }
}


