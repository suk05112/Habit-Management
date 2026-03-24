//
//  Total.swift
//  Habit Management
//
//  Created by 한수진 on 2022/05/15.
//

import Foundation

enum Total: String {
    case week
    case month
    case year
    case all

    var localizedTitle: String {
        switch self {
        case .week: return L10n.tr("stats.total.week")
        case .month: return L10n.tr("stats.total.month")
        case .year: return L10n.tr("stats.total.year")
        case .all: return L10n.tr("stats.total.all")
        }
    }
}
