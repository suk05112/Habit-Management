//
//  FirstLaunchView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/15.
//

import Foundation
import SwiftUI

struct FirstLaunchView : View{
    @State var show: Bool = true
    @State var textlimiter = TextLimiter()
    @State private var showNameRequiredError = false

    @Binding var userName : String
    @Binding var hasLaunched: Bool


    var body: some View {
        if show{
            ZStack{
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.vertical)
                VStack{
//                    HStack{}
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .scaledFrame(width: .none, height: 250)
                            .foregroundColor(Color.white)
                            .scaledPadding(top: 0, leading: 20, bottom: 0, trailing: 20)

                            
                        VStack(alignment: .leading){

                            Text("이름을 입력해 주세요")
                                .scaledText(size: 20, weight: .none)
                                .scaledPadding(top: 0, leading: 5, bottom: 0, trailing: 25)

                            VStack(alignment: .center){
                                TextField(
                                    "8자 이내",
                                    text: Binding(
                                        get: { textlimiter.value },
                                        set: { textlimiter.value = $0; showNameRequiredError = false }
                                    )
                                )
                                    .scaledPadding(top: 5, leading: 15, bottom: 5, trailing: 15)
                                    .scaledText(size: 25, weight: .none)
                                    .foregroundColor(Color.black)
                                    .background(Color(.systemGray6))

                                if showNameRequiredError {
                                    Text("이름을 입력해주세요")
                                        .foregroundColor(.red)
                                        .scaledText(size: 14, weight: .medium)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .scaledPadding(top: 6, leading: 4, bottom: 0, trailing: 0)
                                }

                                HStack{
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(Color(hex: "#639F70"))
                                        .scaledFrame(width: 60, height: 30)
                                        .overlay(
                                            Text("확인")
                                         )
                                        .onTapGesture {
                                            let trimmed = textlimiter.value.trimmingCharacters(in: .whitespacesAndNewlines)
                                            guard !trimmed.isEmpty else {
                                                showNameRequiredError = true
                                                return
                                            }
                                            showNameRequiredError = false
                                            userName = trimmed
                                            hasLaunched = true
                                            show = false
                                        }
                                }

                            }
                        }
                        .scaledPadding(top: 0, leading: 40, bottom: 0, trailing: 40)
                    }

                    Spacer()

                }

            }
          
        }

    
    }
}
struct ContentView_Previews2: PreviewProvider {
    @State static var str = ""
    @State static var hasLaunched = false
    static let setting = Setting()

    static var previews: some View {
        FirstLaunchView(show: true, userName: $str, hasLaunched: $hasLaunched)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(setting)

    }
}
