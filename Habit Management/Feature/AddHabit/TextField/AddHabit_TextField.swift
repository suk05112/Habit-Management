//
//  AddHabit_TextField.swift
//  Habit Management
//
//  Created by 서충원 on 6/24/25.
//

import SwiftUI

extension AddHabitView {
    struct TextFieldView: View {
        @State var title: String = ""
        
        var body: some View {
            TextField("", text: $title, prompt: placeHolder)
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(HabitColor.defaultGray.color, lineWidth: 1)
                )
                .accentColor(HabitColor.mediumGreen.color)
                .foregroundColor(HabitColor.blackGreen.color)
                .scaledText(size: 20, weight: .regular)
                .scaledPadding(top: 0, leading: 20, bottom: 0, trailing: 20)
            //                .focused($isFocused)
        }
        
        private var placeHolder: Text {
            Text("제목을 입력하세요")
                .foregroundColor(HabitColor.defaultGray.color)
                .font(.system(size: 20, weight: .regular))
        }
    }
}
