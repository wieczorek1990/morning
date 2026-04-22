import SwiftUI

struct ItemDetailView: View {
    @Bindable var item: Item
    @Environment(\.modelContext) private var modelContext
    @FocusState private var editionFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle(isOn: $item.isCompleted) {
                Text(item.details)
                    .strikethrough(item.isCompleted, color: .secondary)
                    .font(.headline)
            }
            
            TextEditor(text: $item.details)
                .font(.body)
                .padding()
                .focused($editionFocused)
            
            Text("Utworzono: \(item.timestamp, style: .date)")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding()
        .navigationTitle(item.isCompleted ? "Zakończone" : "Edytuj")
        .onAppear {
            editionFocused = true
        }
    }
}
