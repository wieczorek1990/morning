import Foundation
import SwiftData

@Model
final class Item {
  var id: UUID
  var timestamp: Date
  var details: String
  var isCompleted: Bool

  init(details: String, isCompleted: Bool = false, id: UUID = UUID(), timestamp: Date = Date()) {
    self.details = details
    self.isCompleted = isCompleted
    self.timestamp = timestamp
    self.id = id
  }
}
