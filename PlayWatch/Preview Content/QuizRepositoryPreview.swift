//
//  QuizRepositoryPreview.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Foundation

#if DEBUG

struct QuizRepositoryPreview: QuizRepositoryProtocol {
    
    var simulatedDelay: Duration = .seconds(0.5)
    
    func fetchQuiz(for movies: String, using server: AIServer, in language: String) async throws -> [Quiz] {
        
        try await Task.sleep(for: simulatedDelay)
        return Quiz.previewQuizList
    }
}

#endif
