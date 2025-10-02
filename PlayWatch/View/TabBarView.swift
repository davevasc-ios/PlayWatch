//
//  TabBarView.swift
//  PlayWatch
//
//  Created by David on 14/4/24.
//

import SwiftUI

struct TabBarView: View {
    @State var selectedTab: AppTab = .home
        
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("\(AppTab.home.localized)", systemImage: AppTab.home.systemImage, value: AppTab.home) {
                HomeView()
            }
            Tab("\(AppTab.game.localized)", systemImage: AppTab.game.systemImage, value: AppTab.game) {
                GameView()
            }
            Tab("\(AppTab.favorites.localized)", systemImage: AppTab.favorites.systemImage, value: AppTab.favorites) {
                FavoritesView()
            }
            Tab("\(AppTab.settings.localized)", systemImage: AppTab.settings.systemImage, value: AppTab.settings) {
                SettingsView()
            }
            Tab(value: AppTab.search, role: .search)  {
                SearchView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .sensoryFeedback(.selection, trigger: selectedTab)
    }
}

#if DEBUG
#Preview {
    TabBarView()
}
#endif
