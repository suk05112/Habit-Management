//
//  File.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/08.
//

import Foundation
import SwiftUI

struct Graph: View{
    
    var ratio:Double

    init(ratio: Double){
        self.ratio = ratio
    }
    
    var body: some View {
        
        HStack(alignment: .bottom){
            
            VStack{

                Text("4")
                    .font(.system(size: 12))

                Spacer()
                Text("2")
                    .font(.system(size: 12))

                Spacer()
                Text("0")
                    .font(.system(size: 12))

            }

            Spacer(minLength: 3)
            VStack{
                HStack(alignment: .bottom) {
                    ForEach(0..<12) { month in
                            Rectangle()
                                .fill(Color(hex: "#639F70"))
                                .frame(width: 13, height: CGFloat(month+1) * 10.0)
//                                .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
                            Spacer()

                    }

                }
                .frame(width: 300)

                Divider().background(Color.black)
                    .frame(width: 340)
            }
           
        }

    .frame(width: 364, height: 150)
    .padding(30)

        
        
        
    }
}

struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        Graph(ratio: 1).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
