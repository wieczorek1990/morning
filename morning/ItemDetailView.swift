import SwiftData
import SwiftUI

struct ItemDetailView: View {
  @Bindable var item: Item
  @Environment(\.modelContext) private var modelContext
  @State private var tapped = false

  func setEmpty() {
    item.details = String(localized: "New item...")
  }

  func clearDetails() {
    self.item.details = ""
  }

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
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: clearDetails) {
          Label(String(localized: "Clear"), systemImage: "xmark.circle.fill")
        }
      }
    }
    .onAppear {
      if item.isNew {
        item.isNew = false
      }
    }.onDisappear {
      if item.details.isEmpty {
        item.isNew = true
        setEmpty()
      }
    }
    .gesture(tap)
  }
}
