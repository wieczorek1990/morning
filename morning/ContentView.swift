import Combine
import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var items: [Item]
  @State private var currentDate = Date.now

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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
    }.onReceive(
      NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
    ) { _ in
      checkAndClearIfNeeded()
    }.onAppear {
      guard UserDefaults.standard.object(forKey: LAST_CLEARED_DATE) is Date
      else {
        setLastClearedDate()
        return
      }
    }
    Text("\(currentDate)")
      .onReceive(timer) { input in
        currentDate = input
      }
  }

  private func checkAndClearIfNeeded() {
    guard let lastClearedDate = UserDefaults.standard.object(forKey: LAST_CLEARED_DATE) as? Date
    else {
      return
    }

    let now = Date()
    let yesterdayMorning = Calendar.current.date(
      bySettingHour: 7 + 2,  // CET == GMT + 2
      minute: 0,
      second: 0,
      of: now.yesterday
    )!
    let differenceInSeconds = lastClearedDate.timeIntervalSince(yesterdayMorning)

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
  private func setLastClearedDate() {
    UserDefaults.standard.set(
      Date(), forKey: LAST_CLEARED_DATE
    )
  }
  private func clearItems() {
    withAnimation {
      for item in items {
        item.isCompleted = false
      }
      try? modelContext.save()
      setLastClearedDate()
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
    .environment(\.scenePhase, .active)
}
