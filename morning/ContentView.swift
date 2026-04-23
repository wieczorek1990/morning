import Combine
import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var items: [Item]

  var body: some View {
    NavigationView {
      List {
        ForEach(items) { item in
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
      let newItem = Item(details: "New item")
      modelContext.insert(newItem)
    }
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(items[index])
      }
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
