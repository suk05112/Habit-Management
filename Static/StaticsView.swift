//
//  StaticsView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/03.
//

import Foundation
import SwiftUI

struct StaticsView: View {

    @State var ratio: Double = Double(5/6)
    @StateObject var completedVM = compltedLIstVM.shared


    var body: some View {
        VStack{
            HStack{
                Text("Statics")
                    .font(.system(size: 30))
                Spacer()
                
            }
            .padding()
            scrollView(ratio: 5/6)
            
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
                            HStack{
                                Text("지난 주 대비")
                                    .font(.system(size: 12))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing:0 ))
                                Text("20% up")
                                    .font(.system(size: 12))
                                    .bold()
                                    .foregroundColor(Color(hex: "#38AC3C"))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing:0 ))
                            }
                            
                        }
                        Spacer()
                        HStack{}
                    }
                    .padding(20)
                    

                }
                
            }
            Graph(ratio: 1)
            Spacer()
            HStack{
                
                TotalView(.week, countStatic: completedVM.getStatics(staticCase: ))
                TotalView(.month, countStatic: completedVM.getStatics(staticCase: ))
                TotalView(.year, countStatic: completedVM.getStatics(staticCase: ))
                TotalView(.all, countStatic: completedVM.getStatics(staticCase: ))

            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
        }
    }
}

struct TotalView: View{
    
    var staticStr: String
    var count = 0
    
    init(_ staticCase: Total, countStatic: (Total) -> (Int)){
        staticStr = staticCase.rawValue
        count = countStatic(staticCase)
    }
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 85, height: 57)
                .shadow(radius: 1)
            VStack{
                Text("\(count)")
                    .font(.system(size: 23, weight: .thin))
                Text("\(staticStr)")
                    .font(.system(size: 12, weight: .regular))
            }
            
        }
    }

}

enum Total: String{
    case week = "이번주"
    case month = "이번달"
    case year = "올해"
    case all = "전체"
}
