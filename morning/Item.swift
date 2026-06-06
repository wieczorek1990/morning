import Foundation
import SwiftData

@Model
final class Item {
  var id: UUID
  var created: Date
  var modified: Date
  var details: String
  var isCompleted: Bool
  var isNew: Bool
  var scheduledToDelete: Bool = false

  init(
    details: String, isCompleted: Bool = false, isNew: Bool = true, id: UUID = UUID(),
    timestampCreated: Date = Date(), timestampModified: Date = Date()
  ) {
    self.details = details
    self.isCompleted = isCompleted
    self.created = timestampCreated
    self.modified = timestampModified
    self.id = id
    self.isNew = isNew
  }
}
