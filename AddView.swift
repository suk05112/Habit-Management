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
    @State var iter: Bool = false

    var body: some View {
        
        if show{
            ZStack{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .frame(width: .none, height: 120)
                VStack(alignment: .leading){
                    TextField("제목을 입력하세요", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 25))
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
                    HStack{
                        ForEach(1..<8){
                            WeekButton(weekOfDay: $0)
                        }
                    }.padding(.leading, 30)
                }

            }
            .onTapGesture {
                    //nothing to do but It is necessary to prevent mainView's touch event
                    
            }
        }

    }
}

struct WeekButton: View{
    @State var weekOfDay: Int = 1
    @State var OnOff: Bool = false
    
    var body: some View {
        Button(action:{
            OnOff.toggle()
        }){
            ZStack{
                Circle()
                    .fill(OnOff ? Color.green: Color.yellow)
                    .frame(width: 35, height: 35)
                Text(getWeekOfDay(num:weekOfDay)).foregroundColor(Color.black)
            }
        }

    }

    
    func getWeekOfDay(num: Int) -> String{
        return Week(rawValue: num)!.description
    }
}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


