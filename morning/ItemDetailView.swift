import SwiftData
import SwiftUI

struct ItemDetailView: View {
  @Bindable var item: Item
  @Environment(\.modelContext) private var modelContext
  @State private var tapped = false

  var tap: some Gesture {
    TapGesture(count: 1)
      .onEnded { _ in self.tapped = !self.tapped }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      if self.tapped {
        TextEditor(text: $item.details)
          .font(.body)
          .padding()
          .onChange(of: item.details) {
            item.timestampModified = Date()
          }
      } else {
        Text(item.details)
          .foregroundStyle(.blue)
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
    }.onDisappear {
      if item.details.isEmpty {
        item.details = String(localized: "New item...")
        item.isNew = true
      }
    }
    .gesture(tap)
  }
}
