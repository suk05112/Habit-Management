//
//  Setting.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/28.
//

import Foundation
import SwiftUI

class Setting: ObservableObject {
    @Published var isShowAll: Bool
    @Published var isHideCompleted: Bool
    
    let standardWidth:Double = 414
    let standardHeight:Double = 896
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var WidthRatio: Double
    var HeightRatio: Double = 1
    @State var wasLaunchedBefore = false
    
    init(){
        print("11size", screenWidth, screenHeight)
        WidthRatio = screenWidth/standardWidth
        HeightRatio = screenHeight/standardHeight
        print(WidthRatio, HeightRatio)
        self.isShowAll = UserDefaults.standard.bool(forKey: "showAll")
        self.isHideCompleted = UserDefaults.standard.bool(forKey: "isHideCompleted")
        
        wasLaunchedBefore = firstLaunch()
    }
    
    func setratio() {
    
        if screenHeight == 896 {
            print("iPhone 11, 11proMax, iPhone XR")
        }
        else if screenHeight == 926 {
            print("iPhone 12proMax")
        }
        else if screenHeight == 844 {
            print("iPhone 12, 12pro")
        }
        else if screenHeight == 736 {
            print("iPhone 8plus")
        }
        else if screenHeight == 667 {
            print("iPhone 8")
        }
        else {
            print("iPhone 12 mini, iPhone XS")
        }
    }
    
    func firstLaunch() -> Bool{

        if UserDefaults.standard.object(forKey: "wasLaunchedBefore") == nil{
            UserDefaults.standard.set(false, forKey: "wasLaunchedBefore")
        }
        
        return UserDefaults.standard.bool(forKey: "wasLaunchedBefore")
    }
}

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
