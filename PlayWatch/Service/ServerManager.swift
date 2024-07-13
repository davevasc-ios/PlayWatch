//
//  ServerManager.swift
//  PlayWatch
//
//  Created by David on 13/7/24.
//

import Foundation
import Observation

enum AppServer: String, CaseIterable, Identifiable {
    case openAI = "OpenAI"
    case gemini = "Gemini"
    
    var id: Self { self }
}

@Observable
final class ServerManager {
    
    private let defaults = UserDefaults.standard
    private let appServerKey = "com.playwatch.appServer"
    
    var appServer: AppServer {
        get {
            access(keyPath: \.appServer)
            guard let key = defaults.string(forKey: appServerKey),
                  let server = AppServer(rawValue: key) else {
                return .openAI
            }
            return server
        }
        set {
            withMutation(keyPath: \.appServer) {
                defaults.set(newValue.rawValue, forKey: appServerKey)
            }
        }
    }
}
