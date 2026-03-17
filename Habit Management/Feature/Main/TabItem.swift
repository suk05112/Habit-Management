import SwiftUI

struct TabItem: View {
    let imageName: String
    let title: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
            Text(title)
        }
    }
}

#Preview {
    TabItem(imageName: "house", title: "홈")
}
