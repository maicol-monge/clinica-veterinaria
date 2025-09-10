import SwiftUI

extension Color {
    static let brandPrimary = Color("BrandPrimary") // Naranja
    static let brandSecondary = Color("BrandSecondary") // Gris claro
}

// Si prefieres no usar assets en el catálogo:
extension Color {
    static let fallbackPrimary = Color(red: 1.0, green: 0.45, blue: 0.0) // naranja estilo logo
    static let fallbackSecondary = Color(red: 0.95, green: 0.95, blue: 0.95) // gris claro
}
