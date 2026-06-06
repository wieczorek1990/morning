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

      Text(item.details)
        .lineLimit(1)
        .foregroundStyle(item.scheduledToDelete ? .red : (item.isNew ? .blue : .primary))
        .strikethrough(item.isCompleted, color: .secondary)

      Spacer()
    }
    .contentShape(Rectangle())
  }
}
