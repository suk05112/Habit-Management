//
//  scrollView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/26.
//

import Foundation
import SwiftUI

struct scrollView: View{
    
    let scroll_data = ScrollData()
    
    @StateObject var completedVM = compltedLIstVM.shared
    @Namespace var endPoint
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.green)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .frame(width: .none, height: 280)
            
            HStack{
                VStack(alignment: .center ,spacing:12){
                    Text("SUN")
                    Text("MON")
                    Text("TUE")
                    Text("WED")
                    Text("THU")
                    Text("FRI")
                    Text("SAT")
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 10))
                
                ScrollViewReader { proxy in
                    
                    ScrollView(.horizontal) {
                        
                        VStack(alignment: .center, spacing: 3){
                            HStack(alignment: .center, spacing: 3) {
                                ForEach(scroll_data.MonthArray, id: \.self) { item in
                                    Text(item)
                                        .foregroundColor(.black)
                                        .frame(width: 29, height: 29)
                                }
                            }
                            
                            HStack(alignment: .center, spacing: 3) {
                                
                                ForEach(scroll_data.DayArray, id:\.self){i in
                                    VStack(alignment: .center, spacing: 3) {
                                        ForEach(i, id:\.self){j in
                                            Text("\(j)")
                                                .frame(width: 29, height: 29)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                        .fill(j == "" ? Color.green: getColor(date: j))
                                                        .frame(width: 29, height: 29)
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
