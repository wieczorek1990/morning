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
        if items.isEmpty {
          Image(systemName: "sun.max.fill")
            .font(.system(size: 70))
            .foregroundStyle(
              LinearGradient(
                colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.vertical, 40)
        } else {
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
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: uncompleteItems) {
            Label("Uncomplete Items", systemImage: "minus")
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
      do {
        try modelContext.save()
      } catch {
        print("Failed to add item: \(error.localizedDescription)")
      }
    }
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(items[index])
      }
      do {
        try modelContext.save()
      } catch {
        print("Failed to delete items: \(error.localizedDescription)")
      }
    }
  }
  private func uncompleteItems() {
    withAnimation {
      for item in items {
        item.isCompleted = false
      }
      do {
        try modelContext.save()
      } catch {
        print("Failed to uncomplete items: \(error.localizedDescription)")
      }
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
    .environment(\.scenePhase, .active)
}
