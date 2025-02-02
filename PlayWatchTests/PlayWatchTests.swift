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
        let repository = MovieDBRepositoryPreview()
        
        @Test("Test data loading from MovieDBRepository")
        func testMovieDBDataLoad() async throws {
            do {
                let config = MediaRequestConfig(mediaType: .randomMovies, locale: .init())
                let data = try await repository.fetchMedia(config: config)
                #expect(data.count == 20, "Expected 20 items, but received \(data.count).")
            } catch {
                #expect(Bool(false), "Error loading items: \(error).")
            }
        }
    }
    
    @Suite("MultiAIRepository Tests", .tags(.repository))
    struct MultiAITests {
        let repository = MultiAIRepositoryPreview()
        
        private func testAIServerDataLoad(_ server: AIServer) async throws {
            do {
                let config = GameRequestConfig(movies: .empty, language: .empty, aiServer: server)
                let quiz = try await repository.fetchQuiz(config: config)
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
