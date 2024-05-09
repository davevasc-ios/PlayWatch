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
    private(set) var state: API.Status = .empty
    
    
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
    
    func start(locale: MovieDB.Locale) async throws {
//        await withTaskGroup(of: Void.self) { group in
//            group.addTask {
                self.state = .loading
                do {
                    // TODO: -  PROBAR GEMINI
//                                try await getGeminiResponse(prompt: "cuentame una historia de un azafato en Washington DC")
                    for section in MovieDB.homeSections {
                        let mediaSection = MediaSection(title: section.title,
                                                        items: try await self.fetchMediaUseCase.fetchMedia(type: section, locale: locale, searchText: nil).filterWithImage())
                        self.mediaSectionsList.append(mediaSection)
                    }
                    self.state = .success
                } catch {
                    print(error.localizedDescription)
                    self.state = .error
                }
//            }
//        }
    }
    
    func clean() {
        self.mediaSectionsList.removeAll()
        self.mediaTrendingList.removeAll()
        self.mediaSearchList.removeAll()
        self.state = .empty
    }
    
    func refresh(locale: MovieDB.Locale) async throws {
        self.clean()
        try? await self.start(locale: locale)
    }
    
    func trending(locale: MovieDB.Locale) async throws {
        self.isLoading = true
        defer { self.isLoading = false
        }
        do {
            self.mediaSearchList = try await fetchMediaUseCase.fetchMedia(type: .trendingAll, locale: locale, searchText: nil).filterWithImage()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func search(locale: MovieDB.Locale) async throws {
        self.mediaSearchList.removeAll()
        self.isLoading = true
        defer { self.isLoading = false
        }
        do {
            self.mediaSearchList = try await fetchMediaUseCase.fetchMedia(type: .searchAll, locale: locale, searchText: self.searchText).filterWithImage()
        } catch {
            print(error.localizedDescription)
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
    
    func getGeminiResponse(prompt: String) async throws {
        do {
            self.errorMessage = try await getGeminiUseCase.getResponse(prompt: prompt)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}
