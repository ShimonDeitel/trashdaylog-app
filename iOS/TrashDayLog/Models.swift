import Foundation

struct BinEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var binType: String
    var rotation: String
    var nextDateISO: String

    init(id: UUID = UUID(), createdAt: Date = Date(), binType: String = "", rotation: String = "", nextDateISO: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.binType = binType
        self.rotation = rotation
        self.nextDateISO = nextDateISO
    }
}
