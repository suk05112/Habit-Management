//
//  AddHabitBackground.swift
//  Habit Management
//
//  Created by 서충원 on 6/24/25.
//

import SwiftUI

extension AddHabitView {
    struct BackgroundView<Content: View>: View {
        let content: Content
        
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            ZStack(alignment: .bottom) {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.vertical)
                    .onTapGesture {
    //                    isFocused = false
    //                    viewStore.send(.setHabitTitle(""))
    //                    viewStore.send(.setViewMode)
                    }
                
                content
            }
        }
    }
}
