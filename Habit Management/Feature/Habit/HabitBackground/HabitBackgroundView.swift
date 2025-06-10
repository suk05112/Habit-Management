//
//  HabitBackgroundView.swift
//  Habit Management
//
//  Created by 서충원 on 6/9/25.
//

import SwiftUI

struct HabitBackgroundView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color(hex: "#B8D9B9"))
                .edgesIgnoringSafeArea(.all)
                .scaledFrame(width: nil, height: 242)
            
            content
        }
    }
}
