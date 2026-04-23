import Combine
import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var items: [Item]
  @State private var sortingOldestTop = true

  var body: some View {
    NavigationView {
      List {
        ForEach(
          items.sorted { item1, item2 in
            if sortingOldestTop {
              return item1.timestamp < item2.timestamp
            } else {
              return item1.timestamp > item2.timestamp
            }
          }
        ) { item in
          NavigationLink {
            ItemDetailView(item: item)
          } label: {
            ItemRowView(item: item)
          }
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: clearItems) {
            Label("Clear Items", systemImage: "minus")
          }
        }
        ToolbarItem(placement: .navigationBarLeading) {
          Toggle(isOn: $sortingOldestTop) {
            Image(systemName: "arrow.up.arrow.down")
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem(placement: .primaryAction) {
          Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
    }.onReceive(
      NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
    ) { _ in
      print("Fire...")
    }.onAppear {
      print("Water...")
    }
  }

  private func addItem() {
    withAnimation {
      let newItem = Item(details: String(localized: "New item"))
      modelContext.insert(newItem)
      try? modelContext.save()
    }
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(items[index])
      }
      try? modelContext.save()
    }
  }
  private func clearItems() {
    withAnimation {
      for item in items {
        item.isCompleted = false
      }
      try? modelContext.save()
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
    .environment(\.scenePhase, .active)
}
