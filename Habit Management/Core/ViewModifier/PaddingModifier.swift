//
//  PaddingModifier.swift
//  Habit Management
//
//  Created by 강동영 on 6/12/25.
//

import SwiftUI

struct PaddingModifier: ViewModifier {
    @EnvironmentObject var setting: Setting
    
    var top: CGFloat
    var leading: CGFloat
    var bottom: CGFloat
    var trailing: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(
                EdgeInsets(
                    top: top * setting.WidthRatio,
                    leading: leading * setting.WidthRatio,
                    bottom: bottom * setting.WidthRatio,
                    trailing: trailing * setting.WidthRatio
                )
            )
    }
}