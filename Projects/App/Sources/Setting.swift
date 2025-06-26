//
//  Setting.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/28.
//

import SwiftUI

class Setting: ObservableObject {
    @Published var isShowAll: Bool
    @Published var isHideCompleted: Bool
    @State var wasLaunchedBefore = false
    
    let standardWidth: Double = 414
    let standardHeight: Double = 896
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var widthRatio: Double
    var heightRatio: Double
    var ratioSpacing: CGFloat
    let frameSize: CGFloat = 20
    
    init() {
        widthRatio = screenWidth / standardWidth
        heightRatio = screenHeight / standardHeight
        ratioSpacing = 3 * widthRatio
        
        self.isShowAll = UserDefaults.standard.bool(forKey: "showAll")
        self.isHideCompleted = UserDefaults.standard.bool(forKey: "isHideCompleted")
        wasLaunchedBefore = firstLaunch()
    }
    
    func firstLaunch() -> Bool {
        if UserDefaults.standard.object(forKey: "wasLaunchedBefore") == nil {
            UserDefaults.standard.set(false, forKey: "wasLaunchedBefore")
        }
        
        return UserDefaults.standard.bool(forKey: "wasLaunchedBefore")
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
