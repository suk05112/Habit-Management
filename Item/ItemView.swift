//
//  ItemView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct ItemView: View{
    @EnvironmentObject var setting: Setting
    
    let store: StoreOf<HabitFeature>
    let completionStore: StoreOf<CompletionFeature> = Store(initialState: CompletionFeature.State(), reducer: { CompletionFeature() })
    let habit: Habit
    
    @State private var offset: CGFloat = 0
    @State private var slideRight = false
    @State private var slideLeft = false
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            WithViewStore(completionStore, observe: { $0 }) { completionViewStore in
                if !habit.isInvalidated{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.white)
                            .shadow(radius: 5)
                            .scaledFrame(width: .none, height: 80)
                            .scaledPadding(top: 0, leading: 15, bottom: 0, trailing: 15)
                        
                        HStack{
                            VStack(alignment: .leading){
                                
                                Text("\(habit.weekString()) 반복")
                                    .scaledText(size: 12, weight: .semibold)
                                    .foregroundColor(Color(hex: "#38AC3C"))
                                    .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
                                Text(habit.name)
                                    .scaledText(size: 23, weight: .medium)
                                
                            }
                            
                            Spacer()
                            HStack(){
                                Text("\(habit.continuity)일")
                                    .scaledText(size: 20, weight: .semibold)
                                    .foregroundColor(Color(hex: "#38AC3C"))
                                    .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
                                
                                Text("연속 실천 중🔥")
                                    .scaledText(size: 20, weight: .none)
                                    .scaledPadding(top: 0, leading: -8, bottom: 0, trailing: 0)
                                
                            }
                        }
                        
                        .padding(23*setting.HeightRatio)
                        .opacity(completionViewStore.doneTodayMap[habit.id!] == true ? 0.5 : 1)
                        
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        slideLeft = false
                        slideRight = false
                        offset = 0
                        
                    }
                    .offset(x: offset)
                    .simultaneousGesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
                }
            }
        }
    }
}


extension ItemView {
    
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
