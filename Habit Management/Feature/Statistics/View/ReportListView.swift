//
//  ReportListView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/06/14.
//

import Foundation
import SwiftUI

struct ReportListView: View{
    let reportData: ReportData
    @State var list: [(String, String, String)] = []

    init(reportData: ReportData) {
        self.reportData = reportData
        self._list = State(initialValue: reportData.getReportTextEntries())
    }

    var body: some View {
        VStack{
            HStack{
                Text(L10n.tr("stats.report_title"))
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
