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
    // 1. Initialize your business infrastructure layer safely on the Main Actor
    @State private var productionViewModel: ExploreViewModel
    
    init() {
        let liveService = OnlineEventService()
        _productionViewModel = State(wrappedValue: ExploreViewModel(service: liveService))
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabBarView(viewModel: productionViewModel)
        }
    }
}
