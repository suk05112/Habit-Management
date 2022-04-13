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
    @State var name: String = ""
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
                VStack{
                    TextField("제목을 입력하세요", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 25))
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
                    HStack{
                        ForEach(1..<8){_ in
                            Week()
                        }
                    }
                }.frame(alignment:.leading)

            }
        }

    }
}

struct Week: View{
    var body: some View {
        Button(action:{
            
        }){
            ZStack{
                Circle()
                    .fill(Color.green)
                    .frame(width: 35, height: 35)
                Text("월").foregroundColor(Color.black)
            }
        }

    }
}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


