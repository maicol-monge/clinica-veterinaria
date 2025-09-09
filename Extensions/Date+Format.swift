import Foundation

extension Date {
    var shortFormat: String {
        self.formatted(date: .abbreviated, time: .shortened)
    }
}
