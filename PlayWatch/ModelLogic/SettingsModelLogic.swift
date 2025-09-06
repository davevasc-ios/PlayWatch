//
//  SettingsModelLogic.swift
//  PlayWatch
//
//  Created by David on 23/2/25.
//

import Foundation
import Observation

@Observable
final class SettingsModelLogic {
    
    // MARK: - Private Properties
    @ObservationIgnored private var settingsUtility: SettingsUtilityProtocol

    // MARK: - Initialization
    init(
        settingsUtility: SettingsUtilityProtocol
    ) {
        self.settingsUtility = settingsUtility
    }

    
    var selectedTheme: SettingsView.Theme {
        get {
            access(keyPath: \.selectedTheme)
            return settingsUtility.selectedTheme
        }
        set {
            withMutation(keyPath: \.selectedTheme) {
                settingsUtility.selectedTheme = newValue
            }
        }
    }
    
    var selectedLanguage: AppLanguage {
        get {
            access(keyPath: \.selectedLanguage)
            return settingsUtility.selectedLanguage
        }
        set {
            withMutation(keyPath: \.selectedLanguage) {
                settingsUtility.selectedLanguage = newValue
            }
        }
    }
    
    var selectedRegion: AppRegion {
        get {
            access(keyPath: \.selectedRegion)
            return settingsUtility.selectedRegion
        }
        set {
            withMutation(keyPath: \.selectedRegion) {
                settingsUtility.selectedRegion = newValue
            }
        }
    }
    
    var selectedServer: AIServer {
        get {
            access(keyPath: \.selectedServer)
            return settingsUtility.selectedServer
        }
        set {
            withMutation(keyPath: \.selectedServer) {
                settingsUtility.selectedServer = newValue
            }
        }
    }
    
    var appLocale: Locale {
        Locale(identifier: "\(self.selectedLanguage.languageCode)-\(self.selectedRegion.regionCode)")
    }

    // MARK: - Provisional
    var sectionTitle: String = ""
            
    private func updateSectionTitle() {
        var lang = Tab.settings.localized
        lang.locale = self.appLocale
        self.sectionTitle = String(localized: lang)
    }
}
