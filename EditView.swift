//
//  EditView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/20.
//

import Foundation
import SwiftUI

struct EditView: View{
    @Binding var isEdit: Bool
    var delete: (Habit) -> ()
    @Binding var myItem: Habit
    @State private var showingAlert = false
    @State var iter:[Int] = []
    @State var isShow = false
    
    var body: some View {
//        iter = Array(myItem.weekIter)

        if isEdit{
            ZStack{
                HStack{
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(Color(hex: "#77AC83"))
                        .frame(width: 120, height: 30)
                        .overlay(
                            Text("삭제")
                                .alert(isPresented: $showingAlert) {
                                    Alert(title: Text("삭제하시겠습니까?"), message: Text("이 습관을 삭제해도 완료한 기록은 유지됩니다."), primaryButton: .destructive(Text("확인"), action: {
                                        self.delete(myItem)
                                    }), secondaryButton: .cancel(Text("취소")))
                                }
                                .onTapGesture {
                                    self.showingAlert.toggle()
                                }
                         )
                        
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(Color(hex: "#77AC83"))
                        .frame(width: 120, height: 30)
                        .overlay(
                            Text("수정")
                         )
                        .onTapGesture {
                            isShow.toggle()
                        }
                    
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(Color(hex: "#77AC83"))
                        .frame(width: 120, height: 30)
                        .overlay(
                            Text("중지")
                         )
                        .onTapGesture {
                            
                        }
                }

                if isShow{
//                    AddView(name: $myItem.name, show: true, iter: $iter)

                }
            }
        }

    }

}
