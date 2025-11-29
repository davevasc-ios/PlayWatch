//
//  SettingsView.swift
//  PlayWatch
//
//  Created by David on 2/5/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(AppService.self) private var appService
    
    var body: some View {
        @Bindable var settings = appService.preferencesService
        
        NavigationStack {
            Form {
                Section(header: Text("Apariencia")) {
                    Picker("Theme", selection: $settings.selectedTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.rawValue)
                                .tag(theme)
                        }
                    }
                    Picker("Language", selection: $settings.selectedLanguage) {
                        ForEach(AppLanguage.allCases) { language in
                                Text(language.nativeName)
                                    .tag(language)
                        }
                    }
                    Picker("Region", selection: $settings.selectedRegion) {
                        ForEach(AppRegion.allCases) { region in
                            if region == .system {
                                Text(region.nativeName)
                                    .tag(region)
                            } else {
                                Text("\(region.nativeName) (\(region.localized))")
                                    .tag(region)
                            }
                        }
                    }
                    Picker("Server", selection: $settings.selectedServer) {
                        ForEach(AIServer.allCases) { server in
                            Text(server.rawValue)
                                .tag(server)
                        }
                    }
                }
            }
            .navigationTitle(Text(AppTab.settings.localized))
            .toolbarTitleDisplayMode(.inlineLarge)
            .accountToolbar()
        }
//        .id(appService.preferencesService.selectedLanguage)
    }
}

#if DEBUG
#Preview {
    SettingsView()
        .environment(AppService.preview)
}
#endif
