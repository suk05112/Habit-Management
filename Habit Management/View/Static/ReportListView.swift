//
//  ReportListView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/14.
//

import Foundation
import SwiftUI

struct ReportListView: View{
    @State var list: [(String, String, String)] = ReportData.shared.getReportText()

    var body: some View {
        VStack{
            HStack{
                Text("Report")
                    .font(.system(size: 30))
                    .bold()
                Spacer()
                
            }
            .padding()
            
            ForEach(0..<list.count) { i in
                ReportView(str: $list[i].0, percentHead: $list[i].1, percent: $list[i].2)
            }
            Spacer()
            HStack{}
        }


    }

}
