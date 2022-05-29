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
    @EnvironmentObject var setting: Setting

    
    @State private var showingDetail = false
    @State private var showingAdd = false
    @State private var modalPresented: Bool = false
    @State private var isEdit = false
    @State private var selectedItem = Habit()
    @State private var hideCompleted = false
    @State private var showAll = false
    
    
    @State private var name: String = ""
    @State var iter: [Int] = []
    
    @StateObject var ViewModel = HabitVM.shared
    @StateObject var completedVM = compltedLIstVM.shared
    var staticVM = StaticVM.shared
    var realm: Realm? = try? Realm()

    init(){
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        if UserDefaults.standard.object(forKey: "showAll") == nil{
            UserDefaults.standard.set(false, forKey: "showAll")
        }
        if UserDefaults.standard.object(forKey: "hideCompleted") == nil{
            UserDefaults.standard.set(false, forKey: "hideCompleted")
        }
        self.showAll = UserDefaults.standard.bool(forKey: "showAll")
        self.hideCompleted = UserDefaults.standard.bool(forKey: "hideCompleted")

        UserDefaults.standard.set(false, forKey: "showAll")
        self.showAll = UserDefaults.standard.bool(forKey: "showAll")

    }
    
    var body: some View {
        ZStack{
            TabView{
                ZStack{
                    VStack{
                        ZStack(alignment: .topLeading){
                            Rectangle()
                                .fill(Color(hex: "#B8D9B9"))
                                .edgesIgnoringSafeArea(.all)
                                .customStyle(color: .blue)
                            
                            VStack(alignment: .leading){
                                
                                Text("수진님!\n3일째 물마시기 실천 중!")
                                    .font(.system(size: 25, weight: .bold))
                                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 0))
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: true, vertical: true)
                                
                                scrollView(ratio: 1)
                            }
                            
                        }
                        Spacer()
                        
                        HStack{
                            Text(showAll ? "예정된 습관만 보기" : "습관 모두 보기" )
                                .onTapGesture {
                                    showAll.toggle()
                                    ViewModel.setting(hideCompleted: hideCompleted, showAll: showAll)
                                    UserDefaults.standard.set(showAll, forKey: "showAll")
                                }
                            Spacer()
                            Text(hideCompleted ? "완료된 항목 보이기" : "완료된 항목 숨기기")
                                .onTapGesture {
                                    hideCompleted.toggle()
                                    ViewModel.setting(hideCompleted: hideCompleted, showAll: showAll)
                                }
                        }
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))

                        Spacer()
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(ViewModel.result) { list in
                                ZStack{
                                    EditView(delete: ViewModel.deleteItem(at:),
                                             check: completedVM.complete(id:),
                                             myItem: $ViewModel.result[getItem(habit: list)],
                                             isAddView: $showingAdd,
                                             isEdit: $isEdit,
                                             selectedItem: $selectedItem,
                                             offset: $ViewModel.result[getItem(habit: list)].offset)
//                                    ItemView(myItem: $ViewModel.getResult(habit: list),
//                                             showingModal: $showingDetail,
//                                             offset: $ViewModel.result[getItem(habit: list)].offset,
//                                             name: $ViewModel.result[getItem(habit: list)].name
//                                             )
                                    ItemView(myItem: $ViewModel.result[getItem(habit: list)],
                                             showingModal: $showingDetail,
                                             offset: $ViewModel.result[getItem(habit: list)].offset,
                                             name: $ViewModel.result[getItem(habit: list)].name
                                             )
                                    

                                }

                            }

                        }
                        
                        Spacer()
                        Button(action: {
                            //add item
                            selectedItem = isEdit ? selectedItem : Habit(name: "", iter: [])
                            showingAdd.toggle()
                            modalPresented = true
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
                    staticVM.addOrUpdate()
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
                        Label("label", systemImage: "list.dash")
                        
                    }
            }

            if $showingAdd.wrappedValue{
                AddView(name: $name, show: $showingAdd, isEdit: $isEdit, selectedItem: $selectedItem, iter: Array(selectedItem.weekIter))
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

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct CustomViewModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .frame(height: 242, alignment: .top)
            .readSize { newSize in
              print("The new child size is: \(newSize)")
            }
    }
}

extension View {
    func customStyle(color: Color) -> some View {
        modifier(CustomViewModifier(color: color))
    }
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
      background(
        GeometryReader { geometryProxy in
          Color.clear
            .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
        }
      )
      .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
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
