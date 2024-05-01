//
//  HomeMovieViewModel.swift
//  PlayWatch
//
//  Created by David on 1/4/24.
//

//import Foundation
import Observation

@Observable
final class HomeViewModel {

    private(set) var mediaSectionsList: [MediaSection] = []
    private(set) var mediaTrendingList: [Media] = []
    private(set) var mediaSearchList: [Media] = []
    var searchText = ""
    var isSearching = false
    private(set) var isLoading = false
    
    
//    var users: [User] = []
//    var status: ListStatus = .empty
    var errorMessage = "no working"
    
    // MARK: - Internal vars
    private let fetchMediaUseCase: FetchMediaProtocol
    private let getOpenAIUseCase: GetOpenAIResponseProtocol
    private let getGeminiUseCase: GetGeminiResponseProtocol

    // MARK: - Initialization
    init(
        //        users: [User] = [],
        //         status: ListStatus = .empty,
        //         errorMessage: String = "",
        fetchMediaUseCase: FetchMediaProtocol = FetchMediaUseCase(),
        getOpenAIUseCase: GetOpenAIResponseProtocol = GetOpenAIResponseUseCase(),
        getGeminiUseCase: GetGeminiResponseProtocol = GetGeminiResponseUseCase()) {
            
            
            //        self.users = users
            //        self.status = status
            //        self.errorMessage = errorMessage
            self.fetchMediaUseCase = fetchMediaUseCase
            self.getOpenAIUseCase = getOpenAIUseCase
            self.getGeminiUseCase = getGeminiUseCase
        }
    
    func start() async throws {
        self.mediaSectionsList.removeAll()
        self.isLoading = true
        defer { self.isLoading = false
        }
        do {
            // TODO: -  PROBAR GEMINI
//            try await getGeminiResponse()
            for section in MovieDB.homeSections {
                let mediaSection = MediaSection(title: section.title,
                                                items: try await fetchMediaUseCase.fetchMedia(type: section, searchText: nil).filterWithImage())
                mediaSectionsList.append(mediaSection)
            }
        } catch {
            print(error)
        }
        
    }
    
    func trending() async throws {
        self.isLoading = true
        defer { self.isLoading = false
        }
        do {
            self.mediaSearchList = try await fetchMediaUseCase.fetchMedia(type: .trendingAll, searchText: nil).filterWithImage()
            
        } catch {
            print(error)
        }
    }
    
    func search() async throws {
        self.mediaSearchList.removeAll()
        self.isLoading = true
        defer { self.isLoading = false
        }
        do {
            self.mediaSearchList = try await fetchMediaUseCase.fetchMedia(type: .searchAll, searchText: self.searchText).filterWithImage()
        } catch {
            print(error)
        }
    }
    
    func getOpenAIResponse() async throws {
//        self.users = []
//        self.status = .loading
        do {
            self.errorMessage = try await getOpenAIUseCase.getTextAnswer(prompt: "texto de prueba")
//            self.users = userListModel.results
//            self.status = self.users.isEmpty ? .empty : .success
        }
        catch {
//            self.status = .error
//            self.errorMessage = error.localizedDescription
//            throw error
        }
    }
    
    func getGeminiResponse() async throws {
        do {
            self.errorMessage = try await getGeminiUseCase.getResponse()
        }
        catch {
        }
    }
    
}
