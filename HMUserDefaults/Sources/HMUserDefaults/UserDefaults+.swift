//
//  UserDefaults+.swift
//  HMDesign
//
//  Created by 서충원 on 5/24/25.
//

import SwiftUI

@available(iOS 13.0, *)
public extension Color {
    public init(hex: String){
        let scanner = Scanner(string: hex) //문자 파서역할을 하는 클래스
        _ = scanner.scanString("#")  //scanString은 iOS13 부터 지원 #문자 제거
        
        var rgb: UInt64 = 0
        //문자열을 Int64 타입으로 변환해 rgb 변수에 저장. 변환 할 수 없다면 0 반환
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0 //좌측 문자열 2개 추출
        let g = Double((rgb >> 8) & 0xFF) / 255.0 // 중간 문자열 2개 추출
        let b = Double((rgb >> 0) & 0xFF) / 255.0 //우측 문자열 2개 추출
        self.init(red: r, green: g, blue: b)
    }
    
}

@available(iOS 13.0, *)
public extension View {
    func foregroundColor2(hex: String) -> some View {
        self.foregroundColor(Color(hex: hex))
    }
    
    func background2(hex: String) -> some View {
        self.background(Color(hex: hex))
    }
}
