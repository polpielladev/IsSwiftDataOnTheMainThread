//
//  ContentView.swift
//  IsSwiftDataOnTheMainThread
//
//  Created by Pol Piella Abadia on 14/09/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    private let dataManager: BackgroundDataManager

    @State private var items: [Item] = []

    init(dataManager: BackgroundDataManager) {
        self.dataManager = dataManager
    }

    var body: some View {
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .onAppear {
            Task(priority: .background) {
                try! await fetchAllItems()
            }
        }
    }

    private func fetchAllItems() async throws {
        let items = try await dataManager.getAllItems()
        await MainActor.run {
            self.items = items
        }
    }

    private func addItem() {
        Task {
            await dataManager.insert(item: Item(timestamp: Date()))
            do {
                try await fetchAllItems()
            } catch {}
        }
    }

    private func deleteItems(offsets: IndexSet) {
        Task {
            for index in offsets {
                await dataManager.delete(item: items[index])
            }
            do {
                try await fetchAllItems()
            } catch {}
        }
    }
}
