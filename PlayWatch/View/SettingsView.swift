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
                    Picker("Theme", selection: $settings.selectedTheme) {
                        ForEach(Theme.allCases) { theme in
                            Text(theme.rawValue)
                                .tag(theme)
                        }
                    }
                    .onChange(of: settings.selectedTheme) { _, newTheme in
                        
                    }
                    Picker("Language", selection: $settings.selectedLanguage) {
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
                    .onChange(of: settings.selectedLanguage) { _, newLanguage in
                        if vm.gameModelLogic.state != .loading && vm.gameModelLogic.state != .playing {
                            vm.gameModelLogic.on(.cleanGame)
                            vm.homeModelLogic.on(.reloadData)
                        }
                    }
                    //                    .onChange(of: currentTab) {
                    //                        //                        gameViewModel.clean()
                    //                    }
                    Picker("Region", selection: $settings.selectedRegion) {
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
                    .onChange(of: settings.selectedRegion) { _, newRegion in
                        
                    }
                    Picker("Server", selection: $settings.selectedServer) {
                        ForEach(AIServer.allCases) { server in
                            Text(server.rawValue)
                                .tag(server)
                        }
                    }
                    .onChange(of: settings.selectedServer) { _, newServer in
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
    }
}

#if DEBUG
#Preview {
    SettingsView(currentTab: .constant(.settings))
        .environment(AppViewModel.preview)
}
#endif
