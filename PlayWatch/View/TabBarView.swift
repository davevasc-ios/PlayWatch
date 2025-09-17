//
//  TabBarView.swift
//  PlayWatch
//
//  Created by David on 14/4/24.
//

import SwiftUI

struct TabBarView: View {
        
    var body: some View {
        TabView {
            Tab("\(AppTab.home.localized)", systemImage: AppTab.home.systemImage) {
                HomeView()
            }
            Tab("\(AppTab.game.localized)", systemImage: AppTab.game.systemImage) {
                GameView()
            }
            Tab("\(AppTab.favorites.localized)", systemImage: AppTab.favorites.systemImage) {
                FavoritesView()
            }
            Tab("\(AppTab.settings.localized)", systemImage: AppTab.settings.systemImage) {
                SettingsView()
            }
            Tab(role: .search) {
                SearchView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#if DEBUG
#Preview {
    TabBarView()
}
#endif
