//
//  GameViewModel.swift
//  PlayWatch
//
//  Created by David on 28/4/24.
//


import Observation

@Observable
final class GameViewModel {
    
    private(set) var mediaList: [Media] = []
    private(set) var quizList: [MovieQuiz]  = []
    private(set) var isLoading = false
    
    
    // MARK: - Internal vars
    private let fetchMediaUseCase: FetchMediaProtocol
    private let getOpenAIUseCase: GetOpenAIResponseProtocol
    
    // MARK: - Initialization
    init(fetchMediaUseCase: FetchMediaProtocol = FetchMediaUseCase(),
         getOpenAIUseCase: GetOpenAIResponseProtocol = GetOpenAIResponseUseCase()) {
        self.fetchMediaUseCase = fetchMediaUseCase
        self.getOpenAIUseCase = getOpenAIUseCase
    }
    
    func start() async throws {
        //        self.mediaList.removeAll()
        self.isLoading = true
        defer { self.isLoading = false }
        do {
            self.mediaList = try await fetchMediaUseCase.fetchMedia(type: .randomMovies).filterWithImage()
            self.getMovieNames(mediaList: self.mediaList)
            try await getOpenAIResponse()
        }
        catch {
            print(error)
        }
    }

    
    func getOpenAIResponse() async throws {
        self.isLoading = true
        defer { self.isLoading = false }
        do {
            self.quizList = try await getOpenAIUseCase.getQuiz()
        }
        catch {
            print(error)
        }
    }
    
    private func getMovieNames(mediaList: [Media]) {
        var movieNames = ""
        for media in mediaList {
            if movieNames.isEmpty {
                movieNames = media.mediaName
            } else {
                movieNames += ", \(media.mediaName)"
            }
        }
        OpenAI.mediaNameList = movieNames
    }
    
}
