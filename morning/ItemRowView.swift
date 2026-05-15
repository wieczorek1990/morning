import SwiftData
import SwiftUI

struct ItemRowView: View {
  let item: Item
  @Environment(\.modelContext) private var modelContext

  var body: some View {
    HStack(spacing: 12) {
      Button(action: {
        withAnimation {
          item.isCompleted.toggle()
          do {
            try modelContext.save()
          } catch {
            print("Failed to save item: \(error.localizedDescription)")
          }
        }
      }) {
        Image(systemName: item.isCompleted ? "checkmark.square.fill" : "square")
          .font(.title2)
          .foregroundColor(item.isCompleted ? .blue : .gray)
          .frame(width: 24, height: 24)
      }
      .buttonStyle(PlainButtonStyle())

      if item.isNew {
        Text(item.details)
          .strikethrough(item.isCompleted, color: .secondary)
          .lineLimit(1)
          .foregroundStyle(.blue)
      } else {
        Text(item.details)
          .strikethrough(item.isCompleted, color: .secondary)
          .lineLimit(1)
      }

      Spacer()
    }
    .contentShape(Rectangle())
  }
}
