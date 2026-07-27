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
    @Tag static var media: Self
    @Tag static var quiz: Self
}

@Suite("PlayWatch Tests")
struct PlayWatchTests {

    /// Preview repositories back every case here, so the suite never touches the
    /// network: it stays deterministic, free to run and safe for CI, where no API
    /// keys are available.
    @Suite("MediaRepository Tests", .tags(.repository, .media))
    struct MediaTests {
        let repository = MediaRepositoryPreview(simulatedDelay: .zero)
        let locale = MediaLocale(code: "en", region: "US")

        @Test("Movie fetch types return the movie preview list", arguments: [
            MediaFetchType.cinemaPlaying,
            .cinemaUpcomimg,
            .movieNew,
            .movieTrending,
            .randomMovies,
        ])
        func moviesLoad(for type: MediaFetchType) async throws {
            let media = try await repository.fetchMedia(for: type, with: locale, searchQuery: nil)
            #expect(media == Media.previewMovieList)
        }

        @Test("TV fetch types return the TV preview list", arguments: [
            MediaFetchType.tvNew,
            .tvTrending,
        ])
        func tvShowsLoad(for type: MediaFetchType) async throws {
            let media = try await repository.fetchMedia(for: type, with: locale, searchQuery: nil)
            #expect(media == Media.previewTVList)
        }

        @Test("Person fetch types return the person preview list", arguments: [
            MediaFetchType.personPopular,
            .personTrending,
        ])
        func peopleLoad(for type: MediaFetchType) async throws {
            let media = try await repository.fetchMedia(for: type, with: locale, searchQuery: nil)
            #expect(media == Media.previewPersonList)
        }

        @Test("Mixed fetch types return the combined preview list", arguments: [
            MediaFetchType.searchAll,
            .trendingAll,
        ])
        func mixedContentLoads(for type: MediaFetchType) async throws {
            let media = try await repository.fetchMedia(for: type, with: locale, searchQuery: "test")
            #expect(media == Media.previewAllList)
        }

        /// `fetchMediaSections` is a default implementation on the protocol, so this
        /// exercises the composition every concrete repository inherits — including
        /// the synthetic `.hero` section prepended to the result.
        @Test("Sections are composed with a leading hero section")
        func sectionsCompose() async throws {
            let sections = try await repository.fetchMediaSections(
                for: Constants.homeSections, with: locale
            )
            let first = try #require(sections.first)
            #expect(first.type == .hero)
            #expect(sections.count == Constants.homeSections.count + 1)
            #expect(sections.dropFirst().map(\.type) == Constants.homeSections.map(\.type))
            #expect(first.items == sections.dropFirst().first?.items)
        }
    }

    @Suite("QuizRepository Tests", .tags(.repository, .quiz))
    struct QuizTests {
        let repository = QuizRepositoryPreview(simulatedDelay: .zero)

        @Test("Every AI server returns the quiz preview list", arguments: AIServer.allCases)
        func quizLoads(from server: AIServer) async throws {
            let quiz = try await repository.fetchQuiz(for: "Inception", using: server, in: "en")
            #expect(quiz == Quiz.previewQuizList)
        }
    }
}
