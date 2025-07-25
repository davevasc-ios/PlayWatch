//
//  SettingsView.swift
//  PlayWatch
//
//  Created by David on 2/5/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var currentTab: Tab
    @Environment(AppViewModel.self) private var vm
        
    enum Theme: String, CaseIterable, Identifiable, Codable {
        case light = "Ligero"
        case dark = "Oscuro"
        case rainbows = "Rainbows"
        case pink = "Pink"
        case purple = "Purple"
        case red = "Red"
        case green = "Green"
        case yellow = "Yellow"
        
        var id: Self { self }
    }
    
    var body: some View {
        @Bindable var settings = vm.settingsModelLogic
        
        NavigationStack {
            Form {
                Section(header: Text("Apariencia")) {
                    Picker("Theme", selection: $settings.theme) {
                        ForEach(Theme.allCases) { theme in
                            Text(theme.rawValue)
                                .tag(theme)
                        }
                    }
                    .onChange(of: settings.theme) { _, newTheme in
                        settings.on(.updateTheme(newTheme))
                    }
                    Picker("Language", selection: $settings.language) {
                        ForEach(AppLanguage.allCases) { language in
                            if language == .system {
                                Text(language.nativeName)
                                    .tag(language)
                            } else {
                                Text("\(language.nativeName) (\(language.localized))")
                                    .tag(language)
                            }
                        }
                    }
                    .onChange(of: settings.language) { _, newLanguage in
                        settings.on(.updateLanguage(newLanguage))
                        if vm.gameModelLogic.state != .loading && vm.gameModelLogic.state != .playing {
//                            vm.gameModelLogic.on(.cleanGame)
//                            vm.homeModelLogic.on(.reloadData)
                        }
                    }
                    //                    .onChange(of: currentTab) {
                    //                        //                        gameViewModel.clean()
                    //                    }
                    Picker("Region", selection: $settings.region) {
                        ForEach(AppRegion.allCases) { region in
                            if region == .system {
                                Text(region.localized)
                                    .tag(region)
                            } else {
                                Text("\(region.nativeName) (\(region.localized))")
                                    .tag(region)
                            }
                        }
                    }
                    .onChange(of: settings.region) { _, newRegion in
                        settings.on(.updateRegion(newRegion))
                    }
                    Picker("Server", selection: $settings.server) {
                        ForEach(AIServer.allCases) { server in
                            Text(server.rawValue)
                                .tag(server)
                        }
                    }
                    .onChange(of: settings.server) { _, newServer in
                        settings.on(.updateServer(newServer))
                        if vm.gameModelLogic.state != .loading && vm.gameModelLogic.state != .playing {
//                            vm.gameModelLogic.on(.cleanGame)
//                            vm.homeModelLogic.on(.reloadData)
                        }
                    }
                }
            }
//            .navigationTitle(Text(Tab.settings.localized))
            .navigationTitle(settings.sectionTitle)
        }
        
        .onAppear {
            settings.on(.viewAppear)
        }
    }
}

#if DEBUG
#Preview {
    SettingsView(currentTab: .constant(.settings))
        .environment(AppViewModel.preview)
}
#endif
