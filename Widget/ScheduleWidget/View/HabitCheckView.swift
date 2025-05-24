//
//  HabitCheckView.swift
//  ScheduleWidgetExtension
//
//  Created by 서충원 on 5/23/25.
//

import SwiftUI
import AppIntents
import WidgetKit
import HMDesign

struct HabitCheckView: View {
    
    var entry: ScheduleWidgetEntry
    
    var body: some View {
        VStack(spacing: 0) {
            Button(intent: ToggleButtonIntent()) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.widgetBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                    
                    Image(systemName: entry.showImage ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(entry.showImage ? .green : .gray)
                }
                .frame(width: 80, height: 80)
            }
            .tint(.clear)
            CheckLabelView()
        }
    }
}

struct CheckLabelView: View {
    var body: some View {
        Text("체크하기")
            .fontWeight(.bold)
            .font(.system(size: 12))
            .foregroundColor(hex: "#9ECAA4")
    }
}
