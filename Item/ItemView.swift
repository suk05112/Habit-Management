//
//  ItemView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/23.
//

import Foundation
import SwiftUI

struct ItemView: View{
    @EnvironmentObject var setting: Setting

    @Binding var myItem: Habit
    @Binding var showingModal: Bool
    @Binding var offset: CGFloat
    @Binding var name: String
    
    @State var slideRight = false
    @State var slideLeft = false
    
    @StateObject var completedVM = compltedLIstVM.shared
    
    var body: some View {
        
        if !myItem.isInvalidated{
            ZStack{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .scaledFrame(width: .none, height: 80)
                    .scaledPadding(top: 0, leading: 15, bottom: 0, trailing: 15)

                HStack{
                    VStack(alignment: .leading){
                        
                        Text("\(getWeekStr()) 반복")
                            .scaledText(size: 12, weight: .semibold)
                            .foregroundColor(Color(hex: "#38AC3C"))
                            .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
                        Text(myItem.name)
                            .scaledText(size: 23, weight: .medium)

                    }

                    Spacer()
                    HStack(){
                        Text("\(myItem.continuity)일")
                            .scaledText(size: 20, weight: .semibold)
                            .foregroundColor(Color(hex: "#38AC3C"))
                            .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)

                        Text("연속 실천 중🔥")
                            .scaledText(size: 20, weight: .none)
                            .scaledPadding(top: 0, leading: -8, bottom: 0, trailing: 0)

                    }
                }

                .padding(23*setting.HeightRatio)
                .opacity(completedVM.todayDoneList.completed.contains(myItem.id!) ? 0.5 : 1)
                
            }
            .contentShape(Rectangle())
            .onTapGesture {
                //print("item touch")
//                showingModal = true
                slideLeft = false
                slideRight = false
                offset = 0
                
            }
            .offset(x: offset)
            .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
        }
    }
    
 
    
    func getWeekStr() -> String{
        var str = ""
        let sorted = myItem.weekIter.sorted(by: <)
        if sorted == [2,3,4,5,6]{
            str = "평일"
        }
        else if sorted == [1, 7]{
            str = "주말"
        }
        else if sorted == [1,2,3,4,5,6,7]{
            str = "매일"
        }
        else{
            sorted.forEach{
                str += Week(rawValue: $0)!.kor
            }
        }

        return str
    }
}


extension ItemView{
    
    func onChanged(value: DragGesture.Value){
        //print("offset", value.translation.width)
       
        if value.translation.width < 0 {
            
            if (-value.translation.width < -UIScreen.main.bounds.width/2){
                offset = slideLeft ? value.translation.width - 60 : value.translation.width
            }
            else{
                offset = value.translation.width - 60
            }
            
        }
        else{

            if (value.translation.width < UIScreen.main.bounds.width/2){
                offset = slideRight ? value.translation.width + 110 : value.translation.width
            }
            else{
                offset =  UIScreen.main.bounds.width/2
            }
            
        }

    }
    
    func onEnd(value: DragGesture.Value){
        
        withAnimation(.easeOut){

            if value.translation.width < 0{
                if slideRight{
                    slideRight = false
                    offset = 0
                }

                else{
                    slideLeft = true
                    offset = -60
                }

            }
            else{
                if slideLeft{
                    slideLeft = false
                    offset = 0
                }
                else{
                    slideRight = true
                    offset = 110

                }
            }

        }
        
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
