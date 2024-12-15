//
//  PlayWatchTests.swift
//  PlayWatchTests
//
//  Created by David on 14/12/24.
//

import Testing
@testable import PlayWatch

extension Tag {
    @Tag static var repository: Self
    @Tag static var movieDB: Self
    @Tag static var openAI: Self
    @Tag static var gemini: Self
}

@Suite("PlayWatch Tests")
struct PlayWatchTests {
    
    @Suite("MovieDBRepository Tests", .tags(.repository, .movieDB))
    struct MovieDBTests {
        let repository = MovieDBRepository.test
        
        @Test("Test data loading from MovieDBRepository")
        func testMovieDBDataLoad() async throws {
            do {
                let data = try await repository.fetchMedia(type: .randomMovies, locale: .init())
                #expect(data.count == 20, "Expected 20 items, but received \(data.count).")
            } catch {
                #expect(Bool(false), "Error loading items: \(error).")
            }
        }
    }
    
    @Suite("MultiAIRepository Tests", .tags(.repository))
    struct MultiAITests {
        let repository = MultiAIRepository.test
        
        private func testAIServerDataLoad(_ server: Constants.AIServer) async throws {
            do {
                let quiz = try await repository.fetchQuiz(movies: .empty, language: .empty, aiServer: server)
                #expect(quiz.count == 20, "Server \(server): Expected 20 items, but received \(quiz.count).")
            } catch {
                #expect(Bool(false), "Error testing server \(server): \(error).")
            }
        }
        
        @Test("OpenAI Server", .tags(.openAI))
        func testOpenAIDataLoad() async throws {
            try await testAIServerDataLoad(.openAI)
        }
        
        @Test("Gemini Server", .tags(.gemini))
        func testGeminiDataLoad() async throws {
            try await testAIServerDataLoad(.gemini)
        }
    }
}
