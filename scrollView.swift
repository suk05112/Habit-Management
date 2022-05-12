//
//  scrollView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/26.
//

import Foundation
import SwiftUI

struct scrollView: View{
    
    
    let scroll_data = ScrollData.shared
    var frame_size: CGFloat = CGFloat(24)


    var ratio:Double
    @StateObject var completedVM = compltedLIstVM.shared
    @Namespace var endPoint
    
    
    init(ratio: Double){
        self.ratio = ratio
        frame_size = CGFloat(24*ratio)
    }
    
    var body: some View {

        ZStack{

            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color(hex: "#639F70"))
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .frame(width: .none, height: 250*ratio)
            
            VStack{
                HStack{
                    VStack(alignment: .center ,spacing:12){
                        Text("SUN")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.white)
                            
                        Text("MON")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.white)
                        Text("TUE")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.white)
                        Text("WED")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.white)
                        Text("THU")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.white)
                        Text("FRI")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.white)
                        Text("SAT")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.white)
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 10))
                    
                    ScrollViewReader { proxy in
                        
                        ScrollView(.horizontal) {
                            
                            VStack(alignment: .center, spacing: 3){
                                HStack(alignment: .center, spacing: 3) {
                                    ForEach(scroll_data.MonthArray, id: \.self) { item in
                                        Text(item)
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(Color.white)
    //                                        .foregroundColor(.black)
                                            .frame(width: frame_size, height: frame_size)
                                            
                                    }
                                }
                                
                                HStack(alignment: .center, spacing: 3) {
                                    
                                    ForEach(scroll_data.DayArray, id:\.self){i in
                                        VStack(alignment: .center, spacing: 3) {
                                            ForEach(i, id:\.self){j in
                                                Text("\(j)")
                                                    .frame(width: frame_size, height: frame_size)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                            .fill(j == "" ? Color.green: getColor(date: j))
                                                            .frame(width: frame_size, height: frame_size)
                                                    )
                                            }
                                        }
                                    }
                                    HStack{}.id(endPoint)
                                    
                                }
                                
                            }
                        }
                        .onAppear(){
                            proxy.scrollTo(endPoint)
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25))
                
                HStack{
                    HStack{}
                    Spacer()
                    LessMore()
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25))


            }

        }
    }
    
    func getColor(date: String) -> Color{
        
        let count = completedVM.getCount(d: date)
        //        print("cout =", count)
        
        if count == 0 {
            return Color(hex: "#EFF0EF")
        }
        else{
            return Color(hex: "#C7F0C8")
        }
        
    }
    
}
