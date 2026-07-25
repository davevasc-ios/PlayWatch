//
//  PreviewConstants.swift
//  PlayWatch
//
//  Created by David on 1/2/25.
//

import Foundation

#if DEBUG

struct PreviewConstants {
    
    struct Resource {
        
        enum Name {
            
            static let all = "All"
            static let movies = "Movies"
            static let people = "People"
            static let tvShows = "TVShows"
            static let openAIResponse = "OpenAIResponse"
            static let geminiAIResponse = "GeminiAIResponse"
        }
        
        enum Extension {
            
            static let json = "json"
        }
    }
}

#endif
