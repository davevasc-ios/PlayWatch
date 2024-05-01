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
            self.mediaList = try await fetchMediaUseCase.fetchMedia(type: .randomMovies, searchText: nil).filterWithImage()
            self.quizList = try await getOpenAIUseCase.getMoviesQuiz(movies: self.mediaList.map { $0.mediaName }.joined(separator: ", "))
        }
        catch {
            print(error)
        }
    }

//    
//    func getOpenAIResponse(movies: String) async throws {
//        self.isLoading = true
//        defer { self.isLoading = false }
//        do {
//            self.quizList = try await getOpenAIUseCase.getQuiz(movies: movies)
//        }
//        catch {
//            print(error)
//        }
//    }
    
}
