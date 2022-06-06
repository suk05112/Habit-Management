//
//  EditView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/20.
//

import Foundation
import SwiftUI

struct EditView: View{
    var staticVM = StaticVM.shared
    @StateObject var scrollVM = ScrollVM.shared

    @State private var showingAlert = false

    var delete: (Habit) -> ()
    var check: (String) -> ()
    @Binding var myItem: Habit
    @Binding var isAddView : Bool
    @Binding var isEdit : Bool
    @Binding var selectedItem: Habit
    @Binding var offset: CGFloat

    var body: some View {
        HStack{
            Button(action: {
                self.showingAlert.toggle()
//                deleteItem()
    //                    HabitVM.shared.fetchItem()
                withAnimation(.easeOut){
                            offset = 0
                }
            }){
                Image(systemName: "trash")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 80)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .alert("삭제하시겠습니까?", isPresented: $showingAlert) {
                Button("확인", role: .destructive, action: {
                    deleteItem()
                    print("delete finished")
                })

                Button("취소", role: .cancel){}
            } message: {
                Text("이 습관을 삭제해도 완료한 기록은 유지됩니다.")
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -5))
            
            if !myItem.isInvalidated{
                Button(action: {
                    self.isAddView = true
                    self.isEdit = true
                    self.selectedItem = myItem
                    withAnimation(.easeOut){
                        offset = 0
                    }
                }){
                    Image(systemName: "pencil")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 80)
                        .background(Color(hex: "#92BCA3"))
                        .cornerRadius(10)
                    
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Spacer()
                Button(action: {
                    self.check(myItem.id!)
                    staticVM.addOrUpdate()
                    HabitVM.shared.setContiuity(at: myItem)
                    HabitVM.shared.fetchItem()
                    scrollVM.getThisWeekDayArray()
                }){
                    Image(systemName: "checkmark")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 80)
                        .background(Color(hex: "#D4DED8"))
                        .cornerRadius(10)
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
    
    func deleteItem(){
        print("deleteItem")
        self.delete(myItem)
        print("after delete")
    }
    
    /*
    func isTodaydone() -> Bool{
        let done = compltedLIstVM.shared.istodaydone(id: myItem.id!)
        todaydone = done
        if  done != nil && done == true {
            return true
        }
        else{
            return false
        }
    }
     */
}
