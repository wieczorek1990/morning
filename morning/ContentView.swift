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
        .onDelete(perform: { offsets in
          Task { @MainActor in
            deleteItems(offsets: offsets)
          }
        })
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
    }.onAppear {
      checkAndClearIfNeeded()
    }.onReceive(
      NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
    ) { _ in
      checkAndClearIfNeeded()
    }
  }

  private func checkAndClearIfNeeded() {
    guard let lastClearedDate = UserDefaults.standard.object(forKey: "lastClearedDate") as? Date
    else {
      return
    }

    let now = Date()
    let differenceInSeconds = now.timeIntervalSince(lastClearedDate)

    if differenceInSeconds > DAY_SECONDS {
      DispatchQueue.main.async {
        clearItems()
      }
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
    UserDefaults.standard.set(
      Date(), forKey: "lastClearedDate"
    )
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
    .environment(\.scenePhase, .active)
}
