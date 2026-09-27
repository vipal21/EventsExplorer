//
//  EventsExplorerApp.swift
//  EventsExplorer
//
//  Created by Vipal on 2026-09-27.
//

import SwiftUI
import CoreData

@main
struct EventsExplorerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
