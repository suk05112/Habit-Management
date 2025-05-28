//
//  View.swift
//  Habit Management
//
//  Created by 남경민 on 5/21/25.
//

import Foundation
import SwiftUI

extension View {

    func scaledFrame(width: CGFloat?, height: CGFloat?, isScroll: Bool = false) -> some View {
        modifier(FrameModifier(isScroll: isScroll, width: width, height: height))

    }
    
    func scaledText(size: CGFloat, weight: Font.Weight?) -> some View{
        modifier(FrameModifier(size: size, weight: weight))
    }
    
    func scaledPadding(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> some View{
        modifier(FrameModifier(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }
    
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
      background(
        GeometryReader { geometryProxy in
          Color.clear
            .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
        }
      )
      .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
}
