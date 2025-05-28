//
//  StaticsView.swift
//  Habit Management
//
//  Created by 한수진 on 5/23/25.
//

import SwiftUI
import ComposableArchitecture

struct StaticsView: View {
    var store: StoreOf<StaticsFeature>
    
    @State var ratio: Double = Double(5/6)
    @StateObject var completedVM = compltedLIstVM.shared
    
    @State private var showingDetail = false

    @State var index: Int = 0
    @State var randomText = ReportData.shared.getRandomText()
    
    var body: some View {
        WithPerceptionTracking {
            WithViewStore(store, observe: { $0 }) { viewStore in
                ZStack{
                    VStack{
                        HStack{
                            Text("Statics")
                                .scaledText(size: 30, weight: .semibold)
                            Spacer()
                            
                        }
                        .scaledPadding(top: 10, leading: 20, bottom: 5, trailing: 15)
                        
                        HabitGridView(store: store)
                        
                        ReportView(str: $randomText.0, percentHead: $randomText.1, percent: $randomText.2)
                        .sheet(isPresented: $showingDetail){
                            ReportListView()
                        }
                        .onTapGesture {
                            showingDetail = true
                        }
                        .scaledPadding(top: 10, leading: 0, bottom: 0, trailing: 0)
                        
                        Spacer()
                        Graph(ratio: 1)
                        Spacer()
                        HStack{
                            TotalView(staticCase: .week, store: store)
                            TotalView(staticCase: .month, store: store)
                            TotalView(staticCase: .year, store: store)
                            TotalView(staticCase: .all, store: store)
                        }
                        .scaledPadding(top: 0, leading: 0, bottom: 30, trailing: 0)
                    }
                }.onAppear {
                    viewStore.send(.onAppear)
                    ReportData.shared.setReportText()
                    randomText = ReportData.shared.getRandomText()
                }
            }
        }
    }
}
