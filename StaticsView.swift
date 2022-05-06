//
//  StaticsView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/03.
//

import Foundation
import SwiftUI

struct StaticsView: View {

    var body: some View {
        VStack{
            scrollView()

            
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 150, height: 100)
                    .shadow(radius: 1)
                Text("연속기록")
                
            }
            
            HStack{
                
                TotalView()
                TotalView()
                TotalView()
                TotalView()

            }

        }
    }
}

struct TotalView: View{
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 100, height: 70)
                .shadow(radius: 1)
            Text("test2")
        }
    }

}
