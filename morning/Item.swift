import Foundation
import SwiftData

@Model
final class Item {
  var id: UUID
  var timestamp: Date
  var details: String
  var isCompleted: Bool
  var isNew: Bool

  init(
    details: String, isCompleted: Bool = false, isNew: Bool = true, id: UUID = UUID(),
    timestamp: Date = Date()
  ) {
    self.details = details
    self.isCompleted = isCompleted
    self.timestamp = timestamp
    self.id = id
    self.isNew = isNew
  }
}
