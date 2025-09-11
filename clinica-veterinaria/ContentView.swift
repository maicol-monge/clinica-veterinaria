import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280)
                
                Text("Bienvenidos")
                    .font(.system(size: 34, weight: .bold, design: .rounded)) // ✅ corregido
                    .foregroundStyle(Color.brandPrimary)
                    .padding(.top, 32)

                VStack(spacing: 16) {
                    NavigationLink(destination: MascotasView()) {
                        MenuButton(text: "Mis Mascotas", icon: "pawprint.fill") {}
                    }

                    NavigationLink(destination: CitasView()) {
                        MenuButton(text: "Citas", icon: "calendar") {}
                    }

                    // 🔧 Opción 1: Si no tienes ExpedientesView, comenta o cambia a otra vista
                    NavigationLink(destination: MascotasView()) {
                        MenuButton(text: "Expedientes", icon: "doc.text.fill") {}
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
