//
//  SettingsView.swift
//  PlayWatch
//
//  Created by David on 2/5/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Bindable var localeManager: LocaleManager
    
    @State private var selectedTheme: Theme = .light
    
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
                            Text("\(language.emoji) \(language.localized)")
                                .tag(language)
                        }
                    }
                }
            }
            .navigationTitle(Text(Tab.settings.localized))
        }
    }
}

#Preview {
    SettingsView(localeManager: LocaleManager())
}
