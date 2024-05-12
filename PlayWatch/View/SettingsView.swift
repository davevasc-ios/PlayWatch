//
//  SettingsView.swift
//  PlayWatch
//
//  Created by David on 2/5/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Bindable var localeManager: LocaleManager
    @Binding var currentTab: Tab
    @Environment(GameViewModel.self) private var gameViewModel
    @Environment(HomeViewModel.self) private var homeViewModel

    @State private var selectedTheme: Theme = .light
    @State private var selectedLanguage: AppLanguage = .system
    @State private var isOpenLanguagePicker = false
    
    enum Theme: String, CaseIterable, Identifiable {
        case light = "Ligero"
        case dark = "Oscuro"
        
        var id: String {
            self.rawValue
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Apariencia")) {
                    Picker("Tema", selection: $selectedTheme) {
                        ForEach(Theme.allCases) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    Picker("Idioma", selection: $localeManager.appLanguage) {
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
                    .onChange(of: localeManager.appLanguage) {
                        if gameViewModel.state != .loading {
                            gameViewModel.action(.onClean)
                        }
                        if homeViewModel.state != .loading {
                            homeViewModel.action(.onReload(localeManager.locale))
                        }
                    }
                    .onChange(of: currentTab) {
//                        gameViewModel.clean()
                    }
                    Picker("Region", selection: $localeManager.appRegion) {
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
                }
            }
            .navigationTitle(Text(Tab.settings.localized))
        }
    }
}

//#Preview {
//    SettingsView(localeManager: LocaleManager(), currentTab: Binding<Tab.settings>)
//}
