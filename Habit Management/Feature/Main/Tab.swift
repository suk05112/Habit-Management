import Foundation
import SwiftUI

enum Tab: String, CaseIterable {
    case home
    case statistics
    case settings
    
    var title: String {
        switch self {
        case .home:
            return L10n.tr("tab.home")
        case .statistics:
            return L10n.tr("tab.stats")
        case .settings:
            return L10n.tr("tab.settings")
        }
    }
    
    var imageName: String {
        switch self {
        case .home:
            return "house"
        case .statistics:
            return "chart.bar"
        case .settings:
            return "gearshape"
        }
    }
    
    var tabItem: some View {
        TabItem(imageName: imageName, title: title)
    }
}
