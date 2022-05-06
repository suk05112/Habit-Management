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
    @State var iter: [Int] = []

    
    @StateObject var ViewModel = HabitVM()
    @StateObject var completedVM = compltedLIstVM.shared
    init(){
//        ScrollData()
//        ViewModel.getContinuity()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
    }
    
    var body: some View {
        
        TabView{
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
                            scrollView()
                        }

                    }
                    
                    Spacer()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(ViewModel.result) { list in
                            ItemView(delete: ViewModel.deleteItem(at:), check: completedVM.complete(id:), myItem: $ViewModel.result[getItem(habit: list)],
                                 showingModal: $showingDetail,
                                 offset: $ViewModel.result[getItem(habit: list)].offset)
                        }
                    }
                    
                    Spacer()

                    
                    AddView(name: $name, show: $showingAdd, iter: $iter)
                    Button(action: {
                        //add item
                        showingAdd.toggle()

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
            }
            
            .contentShape(Rectangle())
            .onTapGesture {
                showingAdd = false
                print("Show details for user")
                print(iter)
                ViewModel.addItem(name: name, iter: iter)
                name = ""
                iter = []
                
            }
            .tabItem{
                Image(systemName: "house")
                Text("홈")
            }
            
            Text("글쓰기")
                .tabItem{
                    Image(systemName: "square.and.pencil")
                    Text("글쓰기")
                }
            
            StaticsView()
                .tabItem{
                    Image(systemName: "gear")
                    Text("통계")
                }

            
        }
        

    }
    
    func getItem(habit: Habit)->Int{

        if let index = ViewModel.result.firstIndex(where: { $0 == habit}){
            return index
        }

        return 0

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
