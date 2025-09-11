import SwiftUI

struct MenuButton: View {
    var text: String
    var icon: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(Color.Brand.primary)
                Text(text)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Color.brandPrimary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.brandSecondary.opacity(0.1))
            .cornerRadius(12)
        }
    }
}
