//
//  StaticsView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/03.
//

import Foundation
import SwiftUI

struct StaticsView: View {

    @State var ratio: Double = Double(5/6)
    @StateObject var completedVM = compltedLIstVM.shared
    @StateObject var staticVM = StaticVM.shared
    
    @State private var showingDetail = false

    @State var index: Int = 0
    @State var randomText = ReportData.shared.getRandomText()
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Statics")
                        .scaledText(size: 30, weight: .semibold)
                    Spacer()
                    
                }
                .scaledPadding(top: 10, leading: 20, bottom: 5, trailing: 15)
 
                scrollView()
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
                    TotalView(.week, staticVM: staticVM)
                    TotalView(.month, staticVM: staticVM)
                    TotalView(.year, staticVM: staticVM)
                    TotalView(.all, staticVM: staticVM)

                }
                .scaledPadding(top: 0, leading: 0, bottom: 30, trailing: 0)
            }

        }
        .onAppear {
            //print("static appear")
            ReportData.shared.setReportText()
            randomText = ReportData.shared.getRandomText()
        }

    }
    
}



