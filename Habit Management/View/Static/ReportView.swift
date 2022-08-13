//
//  DetailView.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/13.
//

import Foundation
import SwiftUI

struct ReportView: View{
    @Binding var str: String
    @Binding var percentHead: String
    @Binding var percent: String

    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white)
                .shadow(radius: 5)
                .scaledPadding(top: 0, leading: 15, bottom: 0, trailing: 15)
                .scaledFrame(width: .none, height: 80)
            
            HStack{
                VStack(alignment: .leading){
                    
                    Text("\(str)")
                        .scaledText(size: 15, weight: .medium)
                        .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    HStack{

                        Text("\(percentHead)")
                            .scaledText(size: 12, weight: .none)
                            .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)

                        Text("\(percent)")
                            .scaledText(size: 12, weight: .semibold)
                            .scaledPadding(top: 0, leading: 0, bottom: 0, trailing: 0)
                            .foregroundColor(Color(hex: "#38AC3C"))

                        Spacer()
                        HStack{}
                    }
                }
                Spacer()
                HStack{}
            }
            .scaledPadding(top: 0, leading: 20, bottom: 0, trailing: 35)
            .scaledFrame(width: 400, height: .none)


        }

    }
        
}

