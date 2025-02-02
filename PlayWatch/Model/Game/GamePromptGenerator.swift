//
//  GamePromptGenerator.swift
//  PlayWatch
//
//  Created by David on 2/2/25.
//

import Foundation

enum GamePromptGenerator {
    static func quizPrompt(_ movies: String, _ language: String) -> String {
"""
Give me a just a valid JSON Array of following structure, each one, about one of these movies (no 'movies' field, no 'data' field, just array): \(movies).

Field 1: 'question' (String), a very difficult and original question whose answer is true or false (Ensure that the number of true answers is roughly equal to the number of false answers), about the corresponding movie, in '\(language)' language
Field 2: 'result' (Boolean), the answer of the previous question, which can only be true or false
"""
    }
}
