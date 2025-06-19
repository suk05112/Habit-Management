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
                    .frame(width: width == .none ? .none : width! * setting.widthRatio, height: height == .none ? .none : height! * setting.widthRatio)
            }
            else{
                content
                    .frame(width: width == .none ? .none : width! * setting.widthRatio, height: height == .none ? .none : height! * setting.heightRatio)
            }
            
        }
        if size != nil{
            if let weight = weight {
                content
                    .font(.system(size: size! * setting.widthRatio, weight: weight))
            }
            else{
                content.font(.system(size: size! * setting.widthRatio))
            }
        }
    }
}
