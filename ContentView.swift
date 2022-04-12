//
//  ContentView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/24.
//

import SwiftUI
import CoreData

class ViewModel: ObservableObject {
    var items = [[0, 1], [2, 3], [4, 5]]
    
}


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var showModal = false //상태
    @State private var showDialog = true
    @State private var showingModal = false
    @State private var show = true


    
    @ObservedObject var viewModel = ViewModel()
    @State var selection: Bool? = false
    @State var itemIndex = 0
    
    var body: some View {
        ZStack{
            VStack{
                ZStack(alignment: .topLeading){
                    Rectangle()
                        .fill(Color(hex: "#C7F0C8"))
                        .frame(height: 242, alignment: .top)
                    VStack(alignment: .leading){
                        Text("수진님!\n3일째 물마시기 실천 중!")
                            .bold()
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 0))
                        scroll()
                    }

                }
                AddView(show: $show)
                Button(action: {
                    //add item
                    show.toggle()
                    }) {
                        Text("Add Item")
                    }
                Spacer()

                Button(action: {
                    self.showingModal = true
                    }) {
                        Text("Detail")
                    }
                    Spacer()
                
            }
            
            // The Custom Popup is on top of the screen
              if $showingModal.wrappedValue {
                  DetailView(showingModal: self.$showingModal)

              }
        }

    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

extension Color{
    init(hex: String){
        let scanner = Scanner(string: hex) //문자 파서역할을 하는 클래스
        _ = scanner.scanString("#")  //scanString은 iOS13 부터 지원 #문자 제거
        
        var rgb: UInt64 = 0
        //문자열을 Int64 타입으로 변환해 rgb 변수에 저장. 변환 할 수 없다면 0 반환
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0 //좌측 문자열 2개 추출
        let g = Double((rgb >> 8) & 0xFF) / 255.0 // 중간 문자열 2개 추출
        let b = Double((rgb >> 0) & 0xFF) / 255.0 //우측 문자열 2개 추출
        self.init(red: r, green: g, blue: b)
    }
    
}


struct scroll: View{
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.green)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .frame(width: .none, height: 280)

            VStack{
                HStack(spacing:63){
                    Text("MAR")
                    Text("APR")
                    Text("MAY")
                }
                HStack{
                    VStack(alignment: .center ,spacing:12){
                        Text("SUN")
                        Text("MON")
                        Text("TUE")
                        Text("WED")
                        Text("THU")
                        Text("FRI")
                        Text("SAT")
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 10))
                    ScrollView(.horizontal) {
                        VStack(alignment: .center, spacing: 3) {
                                    ForEach(0...6, id: \.self) { row in
                                        HStack(alignment: .center, spacing: 3) {
                                            ForEach(0...50, id: \.self) { item in
                                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                    .fill(Color(hex: "#EFF0EF"))
                                                    //.fill(Color(red: 52 / 255, green: 152 / 255, blue: 219 / 255))
                                                    .frame(width: 29, height: 29)
                                                    .background(Color.green)
                                                   
                                            }
                                        }
                                    }
                                }
                            }
                    
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25))
                }
            }


        }
    }
    
}

struct AddView: View{
    @State var name: String = ""
    @Binding var show: Bool

    var body: some View {
        
        if show{
            ZStack{
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color.yellow)
                    .frame(width: 200, height: 50)
                TextField("제목을 입력하세요", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .font(.title)
                    .foregroundColor(Color.black)
            }
        }

    }
}

