import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280)

                Text("Bienvenidos")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.Brand.primary)
                    .padding(.top, 32)

                VStack(spacing: 16) {
                    NavigationLink(destination: MascotasView()) {
                        MenuButton(text: "Mascotas", icon: "pawprint.fill")
                            .foregroundStyle(Color.Brand.secondary)
                    }

                    NavigationLink(destination: CitasView()) {
                        MenuButton(text: "Citas", icon: "calendar")
                            .foregroundStyle(Color.Brand.secondary)
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
