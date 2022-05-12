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

    var delete: (Habit) -> ()
    var check: (String) -> ()
    @Binding var myItem: Habit
    @Binding var showingModal: Bool
    @Binding var offset: CGFloat
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.blue)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .frame(width: .none, height: 70)
            
            HStack{
                Spacer()

                Button(action: {deleteItem()}){
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 80, height: 50)
                        
                }
                Button(action: {
                    self.check(myItem.id!)
//                    staticVM.addOrUpdate()
                }){
                    Image(systemName: "checkmark")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 80, height: 50)
                        
                }
            }
            
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
//                                .border(.yellow)

        
                            Text("째 실천 중🔥")
                                .font(.system(size: 12))
                                .padding(EdgeInsets(top: 0, leading: -8, bottom: 0, trailing:0 ))
//                                .border(.yellow)
                                            
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
    
    func deleteItem(){
        self.delete(myItem)
    }
}
