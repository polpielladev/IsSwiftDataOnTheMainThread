//
//  IsSwiftDataOnTheMainThreadApp.swift
//  IsSwiftDataOnTheMainThread
//
//  Created by Pol Piella Abadia on 14/09/2023.
//

import SwiftUI
import SwiftData

@main
struct IsSwiftDataOnTheMainThreadApp: App {
    let dataManager = BackgroundDataManager()

    var body: some Scene {
        WindowGroup {
            ContentView(dataManager: dataManager)
        }
    }
}

actor BackgroundDataManager: ModelActor {
    let modelContainer: ModelContainer
    let modelExecutor: ModelExecutor

    init() {
        let schema = Schema([Item.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        self.modelContainer = try! ModelContainer(for: schema, configurations: [modelConfiguration])
        let modelContext = ModelContext(modelContainer)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
    }

    func insert(item: Item) {
        modelExecutor.modelContext.insert(item)
    }

    func delete(item: Item) {
        modelExecutor.modelContext.delete(item)
    }

    func getAllItems() throws -> [Item] {
        let descriptor = FetchDescriptor<Item>(sortBy: [.init(\.timestamp, order: .reverse)])
        return try modelExecutor.modelContext.fetch(descriptor)
    }
}
