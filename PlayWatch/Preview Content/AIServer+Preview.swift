//
//  AIServer+Preview.swift
//  PlayWatch
//
//  Created by David on 1/2/25.
//

import Foundation

extension AIServer {
    var testResource: String {
        switch self {
        case .openAI, .deepSeek: PreviewConstants.Resource.Name.openAIResponse
        case .gemini: PreviewConstants.Resource.Name.geminiAIResponse
        }
    }
}
