//
//  ReportListView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/14.
//

import Foundation
import SwiftUI

struct ReportListView: View{
    @State var list: [(String, String, String)] = ReportData.shared.getReportTextEntries()

    var body: some View {
        VStack{
            HStack{
                Text("Report")
                    .font(.system(size: 30))
                    .bold()
                Spacer()
                
            }
            .padding()
            
            ForEach(0..<list.count, id: \.self) { rowIndex in
                ReportView(
                    str: $list[rowIndex].0,
                    percentHead: $list[rowIndex].1,
                    percent: $list[rowIndex].2
                )
            }
            Spacer()
            HStack{}
        }


    }

}
