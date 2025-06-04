//
//  ContentView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/03/24.
//
//complete branch

import SwiftUI
import CoreData
import RealmSwift
import Firebase
import ComposableArchitecture

struct MainView: View {
    @Perception.Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                TabView {
                    HabitView (
                        store: store.scope(
                            state: \.habit,
                            action: AppFeature.Action.habit
                        )
                    )
                    .tabItem {
                        Image(systemName: "house")
                        Text("홈")
                    }
                    
                    StaticsView()
                        .tabItem {
                            Image(systemName: "chart.bar.fill")
                            Text("통계")
                        }
                }
                if store.habit.isShowingAdd {
                    AddView(
                        store: store.scope(
                        state: \.habit,
                        action: AppFeature.Action.habit
                        )
                    )
                        .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
                }
                
                if !UserDefaults.standard.bool(forKey: "wasLaunchedBefore") {
                    OnboardingView(userName: $store.habit.userName)
                }
            }
        }
    }
}

struct OnboardingView: View {
    @Binding var userName: String
    
    var body: some View {
        FirstLaunchView(userName: $userName)
            .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}

/*
struct MainView: View {
    @State private var showToast = false

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    @EnvironmentObject var setting: Setting
    @State var mainReport = "아직 완료된 습관이 없습니다"
    @State var mainContinuity = ""
    @State var userName = ""
    
    @State private var showingDetail = false
    @State private var showingAdd = false
    @State private var modalPresented: Bool = false
    @State private var isEdit = false
    @State private var selectedItem = Habit()
    
    
    @ObservedObject private var name = TextLimiter()
    @State var iter: [Int] = []
    
    @StateObject var ViewModel = HabitVM.shared
    @StateObject var completedVM = compltedLIstVM.shared
    var staticVM = StaticVM.shared
    var realm: Realm? = try? Realm()
    
    var ref: DatabaseReference!
    
    init(){
        print("init main")
        
//        UserDefaults.standard.set(1, forKey: "allDoneContinuity")
        print(Realm.Configuration.defaultConfiguration.fileURL!)


        ref = Database.database().reference()
        self.ref.child("users").child("child").setValue(["username": "sujin"])
        
        ref.child("users/child/username").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
          let userName = snapshot?.value as? String ?? "Unknown"
            print(userName, "읽어옴")
        })
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
                                .scaledFrame(width: .none, height: 242)
                            
                            VStack(alignment: .leading){
                                
                                Text("\(userName)님!\n\(mainReport)")
                                    .scaledText(size: 25, weight: .semibold)
                                    .scaledPadding(top: 10, leading: 15, bottom: 0, trailing: 0)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: true, vertical: true)
                                
                                scrollView()
                            }
                            
                        }
                        Spacer()
                        
                        HStack{
                            Text(ViewModel.showAll ? "예정된 습관만 보기" : "습관 모두 보기" )
                                .onTapGesture {
                                    ViewModel.toggleShowAll()
                                }
                            Spacer()
                            Text(ViewModel.hideCompleted ? "완료된 항목 보이기" : "완료된 항목 숨기기")
                                .onTapGesture {
                                    ViewModel.toggleHideComplete()
                                }
                        }
                        .scaledPadding(top: 0, leading: 15, bottom: 0, trailing: 15)
                        
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
                                             offset: $ViewModel.result[getItem(habit: list)].offset, name: $name.value,
                                             showToast: $showToast)

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
                        .scaledPadding(top: 5, leading: 0, bottom: 5, trailing: 0)
                        .opacity(showingAdd ? 0 : 1)
                        
                        Spacer()
                        
                            
                    }
                    
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showingAdd = false
                    print("Show details for user")

                }
                .toast(message: "Current time:\n\(Date().formatted(date: .complete, time: .complete))",
                        isShowing: $showToast,
                        duration: Toast.long)
                .onAppear{
                    print("main appear")
                    if UserDefaults.standard.object(forKey: "userName") != nil{
                        userName = UserDefaults.standard.string(forKey: "userName")!
                    }
                    mainReport = ReportData.shared.getMainReport()
                }
                
                
                .tabItem{
                    Image(systemName: "house")
                    Text("홈")
                }
                
                
////                Text("글쓰기")
//                TestView()
//                    .tabItem{
//                        Image(systemName: "square.and.pencil")
//                        Text("글쓰기")
//                    }
                
                StaticsView()
                    .tabItem{
                        Image(systemName: "chart.bar.fill")
                        Text("통계")
                        Label("label", systemImage: "chart.bar.fill")
                        
                    }
            }

            if $showingAdd.wrappedValue{
                AddView(name: $name.value, show: $showingAdd, isEdit: $isEdit, selectedItem: $selectedItem, iter: Array(selectedItem.weekIter))
                    .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)

            }
            if !UserDefaults.standard.bool(forKey: "wasLaunchedBefore"){
                FirstLaunchView(userName: $userName)
                    .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)

            }
        }
 
    }
    
    func getItem(habit: Habit)->Int{
        if let index = ViewModel.result.firstIndex(where: { $0 == habit}){
            return index
        }
        return 0
    }

}*/

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            store: Store(
                initialState: MainFeature.State(),
                reducer: { MainFeature() }
            )
        )
        .environment(\.managedObjectContext,
                      PersistenceController.preview.container.viewContext
        )
    }
}
*/
