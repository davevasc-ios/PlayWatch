//
//  PromptGenerator.swift
//  PlayWatch
//
//  Created by David on 2/2/25.
//

import Foundation

enum PromptGenerator {
    static func quizPrompt(_ movies: String, _ language: String) -> String {
"""
Give me a just a valid JSON array file of following structure, each one, about one of these movies: \(movies).

Field 1: 'question' (String), a very difficult and original question whose answer is true or false (Ensure that the number of true answers is roughly equal to the number of false answers), about the corresponding movie, in '\(language)' language.
Field 2: 'result' (Boolean), the answer of the previous question, which can only be true or false.

Please return only a valid JSON array, without adding any additional text. The result must start with ‘[’ and end with ‘]’. Do not include any comments, explanations, or extra wrapping.
"""
    }
}
