//
//  Setting.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/28.
//

import Foundation

class Setting: ObservableObject {
    @Published var isShowAll: Bool
    @Published var isHideCompleted: Bool
    
    init(){
        self.isShowAll = UserDefaults.standard.bool(forKey: "showAll")
        self.isHideCompleted = UserDefaults.standard.bool(forKey: "isHideCompleted")
    }
    

}
