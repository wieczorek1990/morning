import Combine
import SwiftData
import SwiftUI

struct ContentView: View {
  private let DELETION_TIMEOUT: Double = 5.0

  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Item.timestampCreated, order: .forward)
  private var items: [Item]
  @State private var sortingOldestTop = true
  @State private var pendingDeletion: (offsets: IndexSet, timer: AnyCancellable?) = (
    offsets: .init(), timer: nil
  )
  @State private var deleteCountdown = 0

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
          ForEach(items) { item in
            NavigationLink {
              ItemDetailView(item: item)
            } label: {
              ItemRowView(item: item)
            }
          }
          .onDelete(perform: requestDeleteItems)
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: uncompleteItems) {
            Label(String(localized: "Uncomplete Items"), systemImage: "minus")
          }
        }
        ToolbarItem(placement: .navigationBarLeading) {
          Toggle(isOn: $sortingOldestTop) {
            Image(systemName: "arrow.up.arrow.down")
          }
        }
        ToolbarItem(placement: .primaryAction) {
          if pendingDeletion.timer != nil {
            Button(action: cancelPendingDeletion) {
              HStack {
                Image(systemName: "xmark.circle.fill")
                  .foregroundStyle(.red)
                Text("\(Int(DELETION_TIMEOUT - Double(deleteCountdown)))")
                  .monospacedDigit()
                  .foregroundStyle(.red)
              }
            }
          } else {
            Button(action: addItem) {
              Label(String(localized: "Add Item"), systemImage: "plus")
            }
          }
        }
      }
      .onReceive(
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
      ) { _ in
        print("Fire...")
      }
      .onAppear {
        print("Water...")
        pendingDeletion = (offsets: .init(), timer: nil)
        deleteCountdown = 0
      }
    }
  }

  private func requestDeleteItems(offsets: IndexSet) {
    guard pendingDeletion.timer == nil else { return }

    pendingDeletion.offsets = offsets
    deleteCountdown = Int(DELETION_TIMEOUT)

    pendingDeletion.timer = Timer.publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .sink { _ in
        deleteCountdown -= 1

        if deleteCountdown <= 0 {
          executeDeletion()
          pendingDeletion = (offsets: .init(), timer: nil)
        }
      }
  }

  private func executeDeletion() {
    withAnimation {
      for offset in pendingDeletion.offsets {
        let itemToDelete = items[offset]
        modelContext.delete(itemToDelete)
      }
      do {
        try modelContext.save()
      } catch {
        print("Failed to delete items: \(error.localizedDescription)")
      }
    }
  }

  private func cancelPendingDeletion() {
    pendingDeletion.timer?.cancel()
    pendingDeletion = (offsets: .init(), timer: nil)
    deleteCountdown = 0
  }

  private func addItem() {
    withAnimation {
      let newItem = Item(details: String(localized: "New item..."))
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
