import Foundation
import SwiftData

@Model
final class Item {
    var id: UUID
    var timestamp: Date
    var details: String
    var isCompleted: Bool
    
    init(timestamp: Date = Date(), details: String, isCompleted: Bool = false) {
        self.id = UUID()
        self.timestamp = timestamp
        self.details = details
        self.isCompleted = isCompleted
    }
}
