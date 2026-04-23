import Foundation

extension Date {
  var yesterday: Date {
    Calendar.current.date(byAdding: .day, value: -1, to: self)!
  }
}
