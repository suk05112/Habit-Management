//
//  DetailView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/13.
//

import Foundation
import SwiftUI

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

            }

        }
        .contentShape(Rectangle())
        .onTapGesture {
            print("바깥쪽 터치됨")
            self.showingModal = false

        }

    }
        
}
