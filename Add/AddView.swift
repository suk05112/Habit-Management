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
    @Binding var name: String
    @Binding var show: Bool
    @Binding var isEdit: Bool
    @Binding var selectedItem: Habit
    @State var iter: [Int]
    @StateObject var ViewModel = HabitVM.shared
    
//    @Binding var showingModal: Bool

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
                            .frame(width: 400, height: 300)
                            .foregroundColor(Color.white)
                            
                        VStack(alignment: .center){
                            TextField("제목을 입력하세요", text: $selectedItem.name)
                                .textFieldStyle(.roundedBorder)
                                .font(.system(size: 25))
                                .foregroundColor(Color.black)
                                .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
                                
                            HStack{
                                ForEach(1..<8){
                                    WeekButton(weekOfDay: $0, iter: $iter, OnOff: Array(self.selectedItem.weekIter).contains($0) ? true : false)
                                }
                            }
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(Color.green)
                                .frame(width: 60, height: 30)
                                .overlay(
                                    Text("저장")
                                 )
                                .onTapGesture {
                                    show = false
                                    if !isEdit{
                                        ViewModel.addItem(name: selectedItem.name, iter: iter)
                                    }
                                    else{
                                        ViewModel.updateItem(name: selectedItem.name, iter: iter, at: selectedItem)
                                        self.isEdit = false
                                    }
                                }
                        }
                    }
                    .onTapGesture {
                        print("modal view touch!")

                    }
                }
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))

            }
            .contentShape(Rectangle())
            .onTapGesture {
                print("바깥쪽 터치됨")
            }
          
        }

    }

}

struct WeekButton: View{
    @State var weekOfDay: Int
    @Binding var iter: [Int]
    @State var OnOff: Bool
    
//    init(weekOfDay: Int, iter: [Int]){
//        self.weekOfDay = weekOfDay
//        self.iter = iter
//        OnOff = iter.contains(weekOfDay) ? true : false
//    }
    
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

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
#endif


