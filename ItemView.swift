//
//  ItemView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/23.
//

import Foundation
import SwiftUI

struct ItemView: View{
    var staticVM = StaticVM.shared
    @StateObject var scrollVM = ScrollVM.shared


    var delete: (Habit) -> ()
    var check: (String) -> ()
    var getcontinue: ()
    @Binding var myItem: Habit
    @Binding var showingModal: Bool
    @Binding var offset: CGFloat
    
    var body: some View {
        ZStack{
//            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                .fill(Color(hex: "#D4DED8"))
//                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
//                .frame(width: .none, height: 80)
            
            HStack{
                Spacer()
                    ZStack(alignment: .trailing){

                HStack{
                    Button(action: {
                        self.check(myItem.id!)
                        self.getcontinue
                        staticVM.addOrUpdate()
                        withAnimation(.easeOut){
                            offset = 0
                        }
                        scrollVM.getThisWeekDayArray()
                    }){
                        Image(systemName: "checkmark")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 80)
                            .background(Color(hex: "#D4DED8"))
                            .cornerRadius(10)
                    }
                    Spacer()
                    HStack{}
                }
                .frame(width: 100, height: 80)
                .foregroundColor(Color(hex: "#D4DED8"))
                
                Button(action: {deleteItem()}){
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 80)
                        .background(Color(hex: "#92BCA3"))
                        .cornerRadius(10)
//                        .cornerRadius(10, corners: .topRight)
//                        .cornerRadius(10, corners: .bottomRight)

                        
                }
            }
                
            }
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            
            ZStack{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .frame(width: .none, height: 80)

                HStack{
                    VStack(alignment: .leading){
                        HStack{
                            Text("\(myItem.continuity)일")
                                .font(.system(size: 12))
                                .bold()
                                .foregroundColor(Color(hex: "#38AC3C"))
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing:0 ))       
                            Text("연속 실천 중🔥")
                                .font(.system(size: 12))
                                .padding(EdgeInsets(top: 0, leading: -8, bottom: 0, trailing:0 ))
                            Spacer()
                        }
                        
                        Text(myItem.name)
                            .font(.system(size: 23, weight: .medium))
                        
                    }
                    Spacer()
                    HStack{}
                }
                .padding(20)
                

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
    
    func deleteItem(){
        self.delete(myItem)
    }
}


extension ItemView{
    func onChanged(value: DragGesture.Value){
        
        if value.translation.width < 0 {
            if myItem.isSwipe{
                offset = value.translation.width - 90
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
                    deleteItem()
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
                myItem.isSwipe = false
                offset = 0
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
