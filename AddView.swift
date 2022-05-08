//
//  Add.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/31.
//

import Foundation
import SwiftUI
import UIKit

struct AddView: View{
    @Binding var name: String
    @Binding var show: Bool
    @Binding var iter: [Int]
    
    @StateObject var ViewModel = HabitVM()

    var body: some View {
        
        if show{
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white)
                        .shadow(radius: 5)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                        .frame(width: .none, height: 120)
                    VStack(alignment: .center){
                        TextField("제목을 입력하세요", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 25))
                            .foregroundColor(Color.black)
                            .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
                        HStack{
                            ForEach(1..<8){
                                WeekButton(weekOfDay: $0, iter: $iter)
                            }
                        }
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.green)
                            .frame(width: 60, height: 30)
                            .overlay(                        Text("저장")
                             )

                            .onTapGesture {
                                show = false
                                ViewModel.addItem(name: name, iter: iter)

                            }

                    }
                    

                }
                
                .onTapGesture {
                        //nothing to do but It is necessary to prevent mainView's touch event
                        
                }

                    
            }

        }

    }
}

struct WeekButton: View{
    @State var weekOfDay: Int = 1
    @State var OnOff: Bool = false
    @Binding var iter: [Int]

    
    var body: some View {
        Button(action:{
            OnOff.toggle()
            if iter.contains(getWeekOfDay(num: weekOfDay).rawValue){
                iter.removeAll(where: {$0 == getWeekOfDay(num: weekOfDay).rawValue})
            }
            else{
                iter.append(Week(rawValue: getWeekOfDay(num: weekOfDay).rawValue)!.rawValue)
            }
            
//            print(iter)

        }){
            ZStack{
                Circle()
                    .fill(OnOff ? Color.green: Color.white)
                    .frame(width: 35, height: 35)
                Text(getWeekOfDay(num:weekOfDay).description).foregroundColor(Color.black)
            }
        }

    }

    
    func getWeekOfDay(num: Int) -> Week{
        return Week(rawValue: num)!
    }
}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


