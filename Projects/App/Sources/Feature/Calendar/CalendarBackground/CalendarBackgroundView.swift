//
//  CalendarBackgroundView.swift
//  Habit Management
//
//  Created by 서충원 on 6/12/25.
//

import SwiftUI

struct CalendarBackgroundView<Content: View>: View {
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(HabitColor.defaultGreen.color)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .scaledPadding(top: 0, leading: 16, bottom: 0, trailing: 16)
    }
}
