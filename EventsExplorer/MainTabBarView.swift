//
//  ContentView.swift
//  EventsExplorer
//
//  Created by Vipal on 2026-09-27.
//

import SwiftUI

struct MainTabBarView: View {
    @State private var selectedTab: Int = 0
    /// Initializer Injection (DI Pattern)
    init() {}
    var body: some View {
        TabView(selection: $selectedTab) {
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "map")
                }
                .tag(0)
            AllEventsListView()
                .tabItem {
                    Label("All Events", systemImage: "calendar")
                }
                .tag(1)

            FavouriteListView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(2)
        }
        .tint(.blue)
    }
}

#Preview {
    MainTabBarView()
}
