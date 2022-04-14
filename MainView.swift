//
//  ContentView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/24.
//

import SwiftUI
import CoreData
import RealmSwift

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var showingDetail = false
    @State private var showingAdd = false
    @State private var name: String = ""
    
    var scrollView = scroll()


    init(){
        print("init")
    
    }

    let realm = try! Realm()
//    let testRealm = Habits(name: "test")

    
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
                
                ForEach(realm.objects(Habits.self), id:\.self){
                    item(name:$0.name, showingModal: $showingDetail)
                }

                AddView(name: $name, show: $showingAdd)
                Button(action: {
                    //add item
                    showingAdd.toggle()
                    try! realm.write {
//                        realm.add(testRealm)
                        let habit = realm.objects(Habits.self)
                        print(habit)
                    }
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(Color.black)
                        
                    }
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    .opacity(showingAdd ? 0 : 1)

                Spacer()

                
            }
              if $showingDetail.wrappedValue {
                  DetailView(showingModal: $showingDetail)

              }
//            remove()
        }
        
        .contentShape(Rectangle())
        .onTapGesture {
            showingAdd = false
            try! realm.write {
                realm.deleteAll()
            }
            
            if !name.isEmpty{
                try! realm.write {
                    realm.add(Habits(name: name))
                    let habit = realm.objects(Habits.self)
                    print(habit)
                }
                name = ""
            }

            print("Show details for user")
            
        }

    }
    
    func remove(){
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
                let realmURLs = [
                  realmURL,
                  realmURL.appendingPathExtension("lock"),
                  realmURL.appendingPathExtension("note"),
                  realmURL.appendingPathExtension("management")
                ]
                
                for URL in realmURLs {
                  do {
                    try FileManager.default.removeItem(at: URL)
                  } catch {
                    // handle error
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
        MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
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

struct item: View{
    
    @State var name: String = ""
    @Binding var showingModal: Bool
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white)
                .shadow(radius: 5)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .frame(width: .none, height: 70)
            Text(name)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            print("item touch")
            showingModal = true

        }
    }
}

struct scroll: View{
    var count = 0
    let items = (1...100)

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
//                                        ForEach(0...50, id: \.self) { i in
//                                            Text("[\(row),\(i)]")
//                                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                        ForEach(items, id: \.self) {_ in

                                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                .fill(Color(hex: "#EFF0EF"))
                                            //.fill(Color(red: 52 / 255, green: 152 / 255, blue: 219 / 255))
                                                .frame(width: 29, height: 29)
                                                .background(Color.green)
//                                                .id(i)
                                                
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        .scaleEffect(x: -1, y: 1, anchor: .center)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25))
                    
                    }
            }


        }
    }
    
}


