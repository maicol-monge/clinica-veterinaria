import SwiftUI

struct MenuButton: View {
    var text: String
    var icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
            Text(text)
                .font(.system(.headline, design: .rounded))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.Brand.primary.opacity(0.2))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}
