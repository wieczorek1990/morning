import SwiftData
import SwiftUI

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
        .onChange(of: item.details) {
          item.timestampModified = Date()
        }

      let createdFormattedDate = item.timestampCreated.formatted(
        date: .abbreviated, time: .shortened
      )
      Text(String(format: String(localized: "Created at: %@"), createdFormattedDate))
        .foregroundColor(.secondary)
        .font(.caption)

      let modifiedFormattedDate = item.timestampModified.formatted(
        date: .abbreviated, time: .standard
      )
      Text(String(format: String(localized: "Modified at: %@"), modifiedFormattedDate))
        .foregroundColor(.secondary)
        .font(.caption)
    }
    .padding()
    .navigationTitle(String(localized: "Edit"))
    .onAppear {
      if item.isNew {
        item.details = ""
        item.isNew = false
      }

      editionFocused = true
    }.onDisappear {
      if item.details.isEmpty {
        item.details = String(localized: "New item...")
        item.isNew = true
      }
    }
  }
}
