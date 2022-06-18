//
//  LessMore.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/08.
//

import Foundation
import SwiftUI

struct LessMore: View {
    @EnvironmentObject var setting: Setting
    var colors = ["#E6E6E6", "#D5EBD3", "#9ECAA4", "#36793F"]
    
    var body: some View {
        HStack{
            Text("Less")
                .scaledText(size: 13, weight: .semibold)
                .foregroundColor(Color.white)
            
            ForEach(colors, id: \.self) { color in
                RoundedRectangle(cornerRadius: 3*setting.WidthRatio, style: .continuous)
                    .LessMoreStyle(color: color )
            }
            Text("More")
                .scaledText(size: 13, weight: .semibold)
                .foregroundColor(Color.white)
        }

    }
}

struct LessMore_Previews: PreviewProvider {
    static var previews: some View {
        LessMore().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct LessMoreModifier: ViewModifier {
    var color: String
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(hex: color))
            .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: -3)
            .scaledFrame(width: 16, height: 16, isScroll: true)

    }
}

extension View {
    func LessMoreStyle(color: String) -> some View{
        modifier(LessMoreModifier(color: color))
    }

}

