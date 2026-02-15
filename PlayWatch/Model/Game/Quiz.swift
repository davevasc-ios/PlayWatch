//
//  Quiz.swift
//  PlayWatch
//
//  Created by David on 16/5/24.
//

import Foundation

struct Quiz: Codable, Hashable {
    let question: String?
    let result: Bool?
}

// MARK: - Decoding
extension Quiz {
    static func decode(from data: Data, using decoder: DataDecoder = JSONDecoder()) throws -> [Self] {
        do {
            return try decoder.decode([Self].self, from: data)
        } catch let decodingError {
            throw API.Error.invalidData(detail: decodingError.localizedDescription)
        }
    }
}

#if DEBUG
// MARK: - Preview Mocks
extension Quiz {
    /// Dato individual para previews
    static let previewQuiz = Quiz(
        question: "Is A Trip to Infinity a documentary film?",
        result: false
    )
    
    /// Lista de 20 elementos para previews
    static let previewQuizList: [Quiz] = [
        Quiz(
            question: "Is A Trip to Infinity a documentary film?",
            result: false
        ),
        Quiz(
            question: "Was Out of the Blue directed by a famous Hollywood director?",
            result: true
        ),
        Quiz(
            question: "Did Justice League: Warworld win an Academy Award?",
            result: false
        ),
        Quiz(
            question: "Is Legion of Super-Heroes based on a comic book series?",
            result: true
        ),
        Quiz(
            question: "Does Batman: The Doom That Came to Gotham feature supernatural elements?",
            result: true
        ),
        Quiz(
            question: "Is Inside the Mind of a Cat a horror movie?",
            result: false
        ),
        Quiz(
            question: "Is Mirreyes contra Godínez 2: El retiro a comedy film?",
            result: true
        ),
        Quiz(
            question: "Does Operation Napoleon take place during World War II?",
            result: false
        ),
        Quiz(
            question: "Is A Million Miles Away a science fiction movie?",
            result: true
        ),
        Quiz(
            question: "Was Monsieur Aznavour nominated for an Oscar?",
            result: false
        ),
        Quiz(
            question: "Is Mission: Cross a spy thriller?",
            result: true
        ),
        Quiz(
            question: "Is Dashing Through the Snow a romantic comedy?",
            result: true
        ),
        Quiz(
            question: "Is Scrooge: A Christmas Carol a modern adaptation of a classic story?",
            result: false
        ),
        Quiz(
            question: "Is Wifelike a documentary about marriage?",
            result: false
        ),
        Quiz(
            question: "Is LaRoy, Texas a western film?",
            result: true
        ),
        Quiz(
            question: "Does Under Paris feature underground catacombs?",
            result: true
        ),
        Quiz(
            question: "Is The Price of Family a drama about family relationships?",
            result: true
        ),
        Quiz(
            question: "Is The Good Teacher based on a true story?",
            result: false
        ),
        Quiz(
            question: "Are The Small Victories and uplifting story?",
            result: true
        ),
        Quiz(
            question: "Is A Great Friend a dark thriller?",
            result: false
        )
    ]
}
#endif
