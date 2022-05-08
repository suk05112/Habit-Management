//
//  LessMore.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/08.
//

import Foundation
import SwiftUI

struct LessMore: View {

    var body: some View {
        HStack{
            Text("Less")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Color.white)
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color(hex: "#E6E6E6"))
                .frame(width: 16, height: 16)
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color(hex: "#CFEECB"))
                .frame(width: 16, height: 16)
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color(hex: "#7BE084"))
                .frame(width: 16, height: 16)
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color(hex: "#36B53D"))
                .frame(width: 16, height: 16)
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color(hex: "#118E15"))
                .frame(width: 16, height: 16)
            Text("More")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Color.white)

        }

    }
}

struct LessMore_Previews: PreviewProvider {
    static var previews: some View {
        LessMore().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
