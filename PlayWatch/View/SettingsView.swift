//
//  SettingsView.swift
//  PlayWatch
//
//  Created by David on 2/5/24.
//

import SwiftUI

struct SettingsView: View {
        
    @Bindable var languageManager: LanguageManager
    
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
                    Picker("Idioma", selection: $languageManager.currentLanguage) {
                        ForEach(Language.allCases) { language in
                            Text("\(language.emoji) \(language.localized)")
                        }
                    }
                    .onChange(of: languageManager.currentLanguage) {
                        
                    }
                }
                
            }
            .navigationTitle(Tab.settings.localized)
        }
    }
}

#Preview {
    SettingsView(languageManager: LanguageManager())
}
