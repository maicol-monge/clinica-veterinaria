import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Patitas Vet Clinic")
                    .font(.system(.largeTitle, weight: .bold, design: .rounded))
                    .foregroundStyle(.brandPrimary)
                    .padding(.top, 32)

                VStack(spacing: 16) {
                    NavigationLink(destination: MascotasView()) {
                        MenuButton(text: "Mis Mascotas", icon: "pawprint.fill") {}
                    }

                    NavigationLink(destination: CitasView()) {
                        MenuButton(text: "Citas", icon: "calendar") {}
                    }

                    NavigationLink(destination: ExpedientesView()) {
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
