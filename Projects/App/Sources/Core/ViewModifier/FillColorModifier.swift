//
//  FillColorModifier.swift
//  Habit Management
//
//  Created by 서충원 on 6/10/25.
//

import SwiftUI

struct FillColorModifier<S: Shape>: ViewModifier {
    let shape: S
    let hexColor: String
    
    func body(content: Content) -> some View {
        shape.fill(Color(hex: hexColor))
    }
}

extension Shape {
    func fillColor(_ color: String) -> some View {
        modifier(FillColorModifier(shape: self, hexColor: color))
    }
}
