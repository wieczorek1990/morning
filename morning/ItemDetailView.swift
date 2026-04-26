import SwiftUI
import SwiftData

struct ItemDetailView: View {
  @Bindable var item: Item
  @Environment(\.modelContext) private var modelContext
  @FocusState private var editionFocused: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Toggle(isOn: $item.isCompleted) {
        Text(item.details.isEmpty ? String(localized: "Empty...") : item.details)
          .strikethrough(item.isCompleted, color: .secondary)
          .font(.headline)
      }

      TextEditor(text: $item.details)
        .font(.body)
        .padding()
        .focused($editionFocused)

        let formattedDate = item.timestamp.formatted(
            date: .abbreviated, time: .shortened
        )
        Text(String(format: String(localized:  "Created at: %@"), formattedDate))
        .foregroundColor(.secondary)
        .font(.caption)
    }
    .padding()
    .navigationTitle(item.isCompleted ? String(localized: "Completed") : String(localized: "Edit"))
    .onAppear {
      editionFocused = true
    }
  }
}
