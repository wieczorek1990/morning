import SwiftUI
import SwiftData

struct ItemDetailView: View {
  @Bindable var item: Item
  @Environment(\.modelContext) private var modelContext
  @FocusState private var editionFocused: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
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
    .navigationTitle(String(localized: "Edit"))
    .onAppear {
      editionFocused = true
    }
  }
}
