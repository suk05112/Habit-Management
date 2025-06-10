import SwiftUI

enum Tab: String, CaseIterable {
    case home
    case statistics
    case settings
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .statistics:
            return "통계"
        case .settings:
            return "설정"
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