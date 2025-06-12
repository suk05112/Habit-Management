//
//  WeekView 2.swift
//  Habit Management
//
//  Created by 한수진 on 5/25/25.
//
import Foundation
import SwiftUI

struct WeekView: View {
    @EnvironmentObject var setting: Setting

    let weekStr: String
    init(week: Int){
        weekStr = Week(rawValue: week)!.description
    }
    var body: some View {
        Text("\(weekStr)")
            .scaledText(size: 10, weight: .bold)
            .foregroundColor(Color.white)
            .scaledFrame(width: .none, height: 20)
            .padding((EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)))
    }
}
