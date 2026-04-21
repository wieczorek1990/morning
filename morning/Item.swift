import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var name: String
    var checked: Bool
    
    init(timestamp: Date, name: String, checked: Bool = false) {
        self.timestamp = timestamp
        self.name = name
        self.checked = checked
    }
}
