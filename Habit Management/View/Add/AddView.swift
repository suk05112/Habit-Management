//
//  Add.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/31.
//

import Foundation
import SwiftUI
import UIKit
import RealmSwift

public struct AddView: View{
    @ObservedObject var textfield = TextLimiter()

    @Binding var name: String
    @Binding var show: Bool
    @Binding var isEdit: Bool
    @Binding var selectedItem: Habit
    @State var iter: [Int]
    @StateObject var ViewModel = HabitVM.shared
    

    public var body: some View {
        if show{
            ZStack{
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.vertical)
                VStack{
                    HStack{}
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .scaledFrame(width: .none, height: 250)
                            .scaledPadding(top: 0, leading: 5, bottom: 0, trailing: 5)
                            .foregroundColor(Color.white)
                            
                        VStack(alignment: .center){
                            HStack{
                                Text("취소")
                                .onTapGesture {
                                    self.name = ""
                                    show = false
                                }
                                Spacer()

                                Text("저장")
                                    .onTapGesture {
                                        show = false
                                        if !isEdit{
                                            ViewModel.addItem(name: name, iter: iter)
                                        }
                                        else{
                                            ViewModel.updateItem(name: name, iter: iter, at: selectedItem)
                                            self.isEdit = false
                                        }
                                        self.name = ""
                                        StaticVM.shared.setnumOfToDoPerDay()
                                        StaticVM.shared.setnumOfToDoPerWeek2(add: true, numOfIter: iter.count)
                                        StaticVM.shared.setnumOfToDoPerMonth(add: true, numOfIter: iter.count)
                                        compltedLIstVM.shared.setAllDoneContinuityUntilToday(status: .add, isToday: isTodayHabit() ? true : false)
                                        
                                    }
                            }
                            .scaledPadding(top: 15, leading: 25, bottom: 10, trailing: 25)

                            TextField("제목을 입력하세요", text: $name)
                                .textFieldStyle(.roundedBorder)
                                .scaledText(size: 25, weight: .none)
                                .foregroundColor(Color.black)
                                .scaledPadding(top: 0, leading: 25, bottom: 0, trailing: 25)
                                
                            HStack{
                                ForEach(1..<8){
                                    WeekButton(weekOfDay: $0, iter: $iter, OnOff: Array(self.selectedItem.weekIter).contains($0) ? true : false)
                                }
                            }
                            .scaledPadding(top: 10, leading: 25, bottom: 10, trailing: 25)
                            Spacer()

                        }
                        .scaledFrame(width: .none, height: 250)

                    }

                }

            }
            .contentShape(Rectangle())

          
        }

    }
    
    func isTodayHabit() -> Bool{
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        
        if iter.contains(todayWeek){
            return true
        }
        else{
            return false
        }
    }

}



#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
#endif



