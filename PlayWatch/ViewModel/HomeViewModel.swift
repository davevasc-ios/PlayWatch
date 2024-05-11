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
//    var isSearching = false
    private(set) var state: API.Status = .empty
        
    // MARK: - Internal vars
    private let fetchMediaUseCase: FetchMediaProtocol
    private let getOpenAIUseCase: GetOpenAIResponseProtocol
    private let getGeminiUseCase: GetGeminiResponseProtocol

    // MARK: - Initialization
    init(fetchMediaUseCase: FetchMediaProtocol = FetchMediaUseCase(),
         getOpenAIUseCase: GetOpenAIResponseProtocol = GetOpenAIResponseUseCase(),
         getGeminiUseCase: GetGeminiResponseProtocol = GetGeminiResponseUseCase()) {
        self.fetchMediaUseCase = fetchMediaUseCase
        self.getOpenAIUseCase = getOpenAIUseCase
        self.getGeminiUseCase = getGeminiUseCase
    }
    
    
    func start(locale: MovieDB.Locale) {
        if state == .empty || state == .error {
            self.state = .loading
            Task {
                do {
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
            }
        }
    }
    
    func clean() {
        self.mediaSectionsList.removeAll()
        self.mediaTrendingList.removeAll()
        self.mediaSearchList.removeAll()
        self.state = .empty
    }
    
    func refresh(locale: MovieDB.Locale) {
        if state != .loading {
            self.clean()
            self.start(locale: locale)
        }
    }
    
    func trending(locale: MovieDB.Locale) {
        Task {
            defer {
            }
            do {
                self.mediaSearchList = try await fetchMediaUseCase.fetchMedia(type: .trendingAll, locale: locale, searchText: nil).filterWithImage()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func search(locale: MovieDB.Locale) {
        self.mediaSearchList.removeAll()
        Task {
            defer {
            }
            do {
                self.mediaSearchList = try await fetchMediaUseCase.fetchMedia(type: .searchAll, locale: locale, searchText: self.searchText).filterWithImage()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getOpenAIResponse() {
        Task {
            do {
                let _ = try await getOpenAIUseCase.getTextAnswer(prompt: "texto de prueba")
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getGeminiResponse(prompt: String) {
        Task {
            do {
                let _ = try await getGeminiUseCase.getResponse(prompt: prompt)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
