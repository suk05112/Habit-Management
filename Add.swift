//
//  Add.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/31.
//

import Foundation
import SwiftUI
import UIKit

struct DetailView: View{
    @Binding var showingModal: Bool

    @State var name: String = ""

    var body: some View {
        ZStack{
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.vertical)
            VStack(alignment: .leading, spacing: 15){
                TextField("제목을 입력하세요", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .font(.title)
                    .foregroundColor(Color.black)
                IterView()
                
                Spacer()
                Button(action: {
                    self.showingModal = false
                }) {
                    Text("Close")
                }.padding()

            }
            .frame(width: 400, height: 300)
            .background(Color.white)
            .cornerRadius(20).shadow(radius: 20)
            .onTapGesture {
                print("modal view touch!")
                hideKeyboard()

            }

        }


    }
        
}

struct IterView: View{
    var body: some View {
        HStack{
            Button(action: {
                }) {
                    Text("매일")
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                }
                .buttonStyle(IterButton())
                
            Button(action: {
                }) {
                    Text("매주")
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                }
                .buttonStyle(IterButton())

            Button(action: {
                }) {
                    Text("매년")
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                }
                .buttonStyle(IterButton())

                
        }
    }
}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct IterButton: ButtonStyle{
    func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
            .background(Color(hex: "#FFD1D1"))
            .cornerRadius(8)
                
        }
    
}

