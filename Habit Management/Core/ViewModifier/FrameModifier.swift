//
//  FrameModifier.swift
//  Habit Management
//
//  Created by 남경민 on 5/21/25.
//

import SwiftUI

struct FrameModifier: ViewModifier {
    @EnvironmentObject var setting: Setting
    
    var isScroll:Bool?
    var width: CGFloat?
    var height: CGFloat?
    
    var size: CGFloat?
    var weight: Font.Weight?
    
    func body(content: Content) -> some View {
        if height != nil || width != nil{
            if isScroll!{
                content
                    .frame(width: width == .none ? .none : width! * setting.WidthRatio, height: height == .none ? .none : height! * setting.WidthRatio)
            }
            else{
                content
                    .frame(width: width == .none ? .none : width! * setting.WidthRatio, height: height == .none ? .none : height! * setting.HeightRatio)
            }
            
        }
        if size != nil{
            if let weight = weight {
                content
                    .font(.system(size: size! * setting.WidthRatio, weight: weight))
            }
            else{
                content.font(.system(size: size! * setting.WidthRatio))
            }
        }
    }
}
