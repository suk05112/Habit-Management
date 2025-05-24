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
    @StateObject var staticVM = StaticVM.shared
    
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
                    }
                }.onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}
