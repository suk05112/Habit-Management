//
//  ItemView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/23.
//

import Foundation
import SwiftUI

struct ItemView: View{
    @Binding var myItem: Habit
    @Binding var showingModal: Bool
    @Binding var offset: CGFloat
    @Binding var name: String
    
    @StateObject var completedVM = compltedLIstVM.shared
    
    var body: some View {
        
        if !myItem.isInvalidated{
            ZStack{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .frame(width: .none, height: 80)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))

                HStack{
                    VStack(alignment: .leading){
                        
                        Text("\(getWeekStr()) 반복")
                            .font(.system(size: 12))
                            .bold()
                            .foregroundColor(Color(hex: "#38AC3C"))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing:0 ))
                        Text(myItem.name)
                            .font(.system(size: 23, weight: .medium))
                    }

                    Spacer()
                    HStack(){
                        Text("\(myItem.continuity)일")
                            .font(.system(size: 23))
                            .bold()
                            .foregroundColor(Color(hex: "#38AC3C"))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing:0 ))
                        Text("연속 실천 중🔥")
                            .font(.system(size: 23))
                            .padding(EdgeInsets(top: 0, leading: -8, bottom: 0, trailing:0 ))
                    }
                }

                .padding(20)
                .opacity(completedVM.todayDoneList.completed.contains(myItem.id!) ? 0.5 : 1)
                
            }
            .contentShape(Rectangle())
            .onTapGesture {
                print("item touch")
                showingModal = true
                
            }
            .offset(x: offset)
            .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
        }
    }
    
 
    
    func isTodayHabit() -> Bool{
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        
        if myItem.weekIter.contains(todayWeek){
            return true
        }
        else{
            return false
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
        print("offset", value.translation.width)
        
        if value.translation.width < 0 {
            if myItem.isSwipe{
                offset = value.translation.width - 90
            }
            else{
                offset = value.translation.width
            }
        }
        else{
            if myItem.isSwipe{
                offset = value.translation.width + 90
            }
            else{
                offset = value.translation.width
            }
        }
    }
    
    func onEnd(value: DragGesture.Value){
        
        withAnimation(.easeOut){
            if value.translation.width < 0{
                
                if -value.translation.width > UIScreen.main.bounds.width/2{
                    offset = -1000
//                    deleteItem()
                }
                else if -myItem.offset > 50{
                    myItem.isSwipe = true
                    offset = -90
                }
                else{
                    myItem.isSwipe = false
                    offset = 0
                }
            }
            else{
                //                myItem.isSwipe = false
                //                offset = 0
                
                if value.translation.width > UIScreen.main.bounds.width/2{
                    offset = 1000
                }
                else if myItem.offset > 50{
                    myItem.isSwipe = true
                    offset = 90
                }
                else{
                    myItem.isSwipe = false
                    offset = 0
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
