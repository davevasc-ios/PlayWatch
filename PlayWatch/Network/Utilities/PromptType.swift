//
//  PromptType.swift
//  PlayWatch
//
//  Created by David on 16/2/25.
//

import Foundation

enum PromptType: CustomStringConvertible {
    case quiz(movies: String, language: String),
         text(String)
    
    var description: String {
        switch self {
        case .quiz(let movies, let language): PromptGenerator.quizPrompt(movies, language)
        case .text(let text): text
        }
    }
}
