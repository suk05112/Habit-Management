//
//  TextLimiter.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/19.
//

import Foundation

class TextLimiter: ObservableObject {
    private let limit: Int = 8
    let endIdx: String.Index = "abcdabcd".index("abcdabcd".startIndex, offsetBy: 8)
    
    init(value: String = ""){
        self.value = value
    }
    
    @Published var value: String{
        didSet {
            if value.count > 9 {
                value = String(value.prefix(8))

            }
            
        }
    }

}
