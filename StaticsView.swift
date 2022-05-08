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
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white)
                        .shadow(radius: 5)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                        .frame(width: .none, height: 80)

                    HStack{
                        VStack(alignment: .leading){
                            Text("지난 주 보다 '물마시기'를 2번 더 완료했어요!")
                                .font(.system(size: 15, weight: .medium))
                            Text("지난 주 대비 20% up")
                                .font(.system(size: 12))
                            
                        }
                        Spacer()
                        HStack{}
                    }
                    .padding(20)
                    

                }
                
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
                .frame(width: 85, height: 57)
                .shadow(radius: 1)
            VStack{
                Text("2")
                    .font(.system(size: 23, weight: .thin))
                Text("이번주")
                    .font(.system(size: 12, weight: .regular))
            }
            
        }
    }

}
