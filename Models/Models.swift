import Foundation
import SwiftData

// MARK: - Dueño
@Model
class Owner {
    var nombre: String
    var telefono: String
    @Relationship(deleteRule: .cascade) var mascotas: [Mascota] = []

    init(nombre: String, telefono: String) {
        self.nombre = nombre
        self.telefono = telefono
    }
}

@Model
class Mascota {
    var id: UUID   // ← NUEVO
    var nombre: String
    private var especieRaw: String
    var raza: String
    var fechaNacimiento: Date
    @Relationship(deleteRule: .nullify) var owner: Owner?
    @Relationship(deleteRule: .cascade) var citas: [Cita] = []

    var especie: Especie {
        get { Especie(rawValue: especieRaw) ?? .perro }
        set { especieRaw = newValue.rawValue }
    }

    init(nombre: String, especie: Especie, raza: String, fechaNacimiento: Date, owner: Owner?) {
        self.id = UUID()   // ← se genera automáticamente
        self.nombre = nombre
        self.especieRaw = especie.rawValue
        self.raza = raza
        self.fechaNacimiento = fechaNacimiento
        self.owner = owner
    }
}


// MARK: - Cita
@Model
class Cita {
    var fecha: Date
    private var servicioRaw: String
    private var estadoRaw: String
    var detalle: String?
    @Relationship(deleteRule: .nullify) var mascota: Mascota?

    // Computed para trabajar con enums
    var servicio: Servicio {
        get { Servicio(rawValue: servicioRaw) ?? .consulta }
        set { servicioRaw = newValue.rawValue }
    }
    
    var estado: EstadoCita {
        get { EstadoCita(rawValue: estadoRaw) ?? .pendiente }
        set { estadoRaw = newValue.rawValue }
    }

    init(fecha: Date, servicio: Servicio, estado: EstadoCita = .pendiente, detalle: String? = nil, mascota: Mascota?) {
        self.fecha = fecha
        self.servicioRaw = servicio.rawValue
        self.estadoRaw = estado.rawValue
        self.detalle = detalle
        self.mascota = mascota
    }
}

// MARK: - Enums
enum Especie: String, CaseIterable, Codable {
    case perro = "Perro"
    case gato = "Gato"
    case conejo = "Conejo"
}

enum Servicio: String, CaseIterable, Codable {
    case consulta = "Consulta médica"
    case emergencia = "Emergencia"

    // Solo para perros
    case banoBasico = "Baño básico"
    case banoUñas = "Baño con recorte de uñas"
    case banoEstetico = "Baño estético"
    case banoMedicado = "Baño medicado"
}

enum EstadoCita: String, CaseIterable, Codable {
    case pendiente = "Pendiente"
    case aceptada = "Aceptada"
    case rechazada = "Rechazada"
    case completada = "Completada"
}
