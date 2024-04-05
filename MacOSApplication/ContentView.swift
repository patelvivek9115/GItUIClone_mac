//
//  ContentView.swift
//  MacOSApplication
//
//  Created by Vivek Patel on 14/03/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    var body: some View {
        HomeView()
            .frame(minWidth: 960, minHeight: 620)
    }
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
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
}
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
/*
NavigationSplitView {
    List {
        ForEach(items) { item in
            NavigationLink {
                Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
            } label: {
                Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
            }
        }
        .onDelete(perform: deleteItems)
    }
    .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    .toolbar {
        ToolbarItem {
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
            Button(action: addItem) {
                Label("Add Item", systemImage: "minus")
            }
        }
    }
} detail: {
    Text("Select an item")
}
*/
