//
//  File.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/08.
//

import Foundation
import SwiftUI

struct Graph: View{
    
    var ratio:Double
    @State var selected = 1
    @State var width:CGFloat = 13
    @StateObject var staticVM = StaticVM.shared
    
    init(ratio: Double){
        self.ratio = ratio
    }
    
    var body: some View {
        
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(hex: "#E8E8E8"))
                    .frame(width: .none, height: 30)
                
                HStack{
                    selectView(name: "최근 7일", id: 1, select: $selected)
                        .onTapGesture {
                            selected = 1
                            width = 20
                        }
                    Spacer()
                    selectView(name: "최근 5주", id: 2, select: $selected)
                        .onTapGesture {
                            selected = 2
                            width = 30
                        }
                    Spacer()
                    selectView(name: "월", id: 3, select: $selected)
                        .onTapGesture {
                            selected = 3
                            width = 10
                        }

                }
            }
            .padding()
            
            HStack(alignment: .bottom){
                
                Spacer(minLength: 3)
                VStack{
                    HStack{
                        VStack{
                            Text("\(staticVM.getData(selected: selected).max()!)")
                                .font(.system(size: 12))

                            Spacer()
                            Text("\(staticVM.getData(selected: selected).max()!/2)")
                                .font(.system(size: 12))

                            Spacer()
                            Text("0")
                                .font(.system(size: 12))
                        }
                        .frame(width: 20, height: 150)
                        
                        VStack{
                            HStack(alignment: .bottom) {
                                ForEach(staticVM.getData(selected: selected), id: \.self) { month in
                                        let max = staticVM.getData(selected: selected).max()!
                                        let h1 = Int(month)*Int(150)
                                        let h2 = Double(h1)/Double(max)
                                        Rectangle()
                                            .fill(Color(hex: "#639F70"))
                                            .frame(width: width, height: h2==0 ? CGFloat(0) : CGFloat(h2))
                                        Spacer()
                                }
                            }
                            .frame(width: 300, height: 150)

                            Divider().background(Color.black)
                                .frame(width: 340)
                        }
                        
                    }
                    
                    /*
                    HStack(alignment: .top) {
                        VStack{}.frame(width: 20)
                        ForEach(0..<staticVM.getData(selected: selected).count, id: \.self) { i in
                                Text("\(staticVM.getStr(selected: selected)[i])")
                                    .font(.system(size: 12, weight: .regular))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(width:width)

                            Spacer()

                            }
                        }
                    .frame(width: 340)
*/
                    }
                }
               
            }

        .frame(width: 364, height: 150)
        .padding(30)

    }
        
    func getData(selected: Int)-> [Int]{
        
        switch selected{
        case 1:
            return staticVM.day
        case 2:
            return staticVM.week
        case 3:
            return staticVM.month
        default:
            return []
        }
    }
        
}

struct selectView: View{
    
    var str: String
    var id: Int = 1
    @Binding var selected: Int
    
    init(name: String, id: Int, select: Binding<Int>){
        self.str = name
        self.id = id
        self._selected = select
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(selected==id ? Color(hex: "#77AC83"): Color(hex: "#E8E8E8"))
            .frame(width: .none, height: 30)
            .overlay{
                Text("\(str)")
                    .font(.system(size: 15))
            }
    }
}

struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        Graph(ratio: 1).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
