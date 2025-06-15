//
//  File.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/08.
//

import SwiftUI
import ComposableArchitecture

struct Graph: View {
    let store: StoreOf<StatisticsFeature>
    
    var ratio: Double
    @State var selected: Total = .week
    @State private var selectedData: [Int] = []
    @State var width:CGFloat = 13
    
    init(store: StoreOf<StatisticsFeature>, ratio: Double) {
        self.store = store
        self.ratio = ratio
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color(hex: "#E8E8E8"))
                        .scaledFrame(width: .none, height: 30)
                    
                    HStack {
                        SelectedView(name: "최근 7일", id: .week, select: $selected)
                            .onTapGesture {
                                selected = .week
                                width = 20
                            }
                        Spacer()
                        SelectedView(name: "최근 5주", id: .month, select: $selected)
                            .onTapGesture {
                                selected = .month
                                width = 30
                            }
                        Spacer()
                        SelectedView(name: "월", id: .year, select: $selected)
                            .onTapGesture {
                                selected = .year
                                width = 10
                            }
                    }
                }
                .scaledPadding(top: 0, leading: 0, bottom: 20, trailing: 0)
                .onChange(of: selected) { newSelected in
                    selectedData = getData(viewStore: viewStore, selected: newSelected)
                }
                .onAppear {
                    selectedData = getData(viewStore: viewStore, selected: selected)
                }
                
                HStack(alignment: .bottom) {
                    Spacer(minLength: 3)
                    VStack {
                        HStack {
                            VStack {
                                let maxValue = selectedData.max() ?? 1
                                
                                Text("\(maxValue)")
                                    .scaledText(size: 12, weight: .none)
                                
                                Spacer()
                                
                                Text(maxValue == 1 ? "" : "\(maxValue/2)")
                                    .scaledText(size: 12, weight: .none)
                                
                                Spacer()
                                Text("0")
                                    .scaledText(size: 12, weight: .none)
                                
                            }
                            .scaledFrame(width: 20, height: 150)
                            
                            VStack {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(Color.white)
                                        .scaledFrame(width: 300, height: 150)
                                        .overlay{
                                            Text("No Data")
                                                .scaledText(size: 15, weight: .none)
                                        }
                                    
                                    if viewStore.staticsData.total != 0 {
                                        HStack(alignment: .bottom) {
                                            ForEach(Array(selectedData.enumerated()), id: \.offset) { index, month in
                                                let max = selectedData.max() ?? 1
                                                let h1 = Int(month)*Int(150)
                                                let h2: Double = (max == 1 && month != 0) ? 150.0 : Double(h1) / Double(max)
                                                
                                                Rectangle()
                                                    .fill(Color(hex: "#639F70"))
                                                    .scaledFrame(width: width, height: max==0 ? CGFloat(0) : CGFloat(h2))
                                                Spacer()
                                            }
                                        }
                                        .background(Color.white)
                                        .scaledFrame(width: 300, height: 150)
                                    }
                                }
                                Divider().background(Color.black)
                                    .scaledFrame(width: 340, height: .none)
                            }
                        }
                    }
                }
            }
        }
        .scaledFrame(width: 364, height: 150)
        .padding(30)
    }
    
    func getData(viewStore: ViewStore<StatisticsFeature.State, StatisticsFeature.Action>, selected: Total)-> [Int] {
        switch selected {
        case .week:
            return viewStore.staticsData.day
        case .month:
            let b = Calendar.current.dateComponents([.weekOfYear], from: Date()).weekOfYear!
            var a = b-5
            
            if a < 1 {
                a = 12 - a
            }
            
            return Array(viewStore.staticsData.week[a..<b])
        case .year:
            return viewStore.staticsData.month
        default:
            return []
        }
    }
}

struct SelectedView: View {
    var str: String
    var id: Total = .week
    @Binding var selected: Total
    
    init(name: String, id: Total, select: Binding<Total>){
        self.str = name
        self.id = id
        self._selected = select
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(selected==id ? Color(hex: "#77AC83"): Color(hex: "#E8E8E8"))
            .scaledFrame(width: .none, height: 30)
            .overlay{
                Text("\(str)")
                    .scaledText(size: 15, weight: .none)
            }
    }
}
