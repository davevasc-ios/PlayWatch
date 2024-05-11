//
//  HomeMovieViewModel.swift
//  PlayWatch
//
//  Created by David on 1/4/24.
//

import Observation

enum HomeViewAction {
    case onAppear(MovieDB.Locale),
         onRefresh,
         onChangeSearch(String),
         onChangeTrending
}

@Observable
final class HomeViewModel {

    private(set) var mediaSectionsList: [MediaSection] = []
    private(set) var mediaTrendingList: [Media] = []
    private(set) var mediaSearchList: [Media] = []
    private var state: API.Status = .empty
    private var locale = MovieDB.Locale()
        
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
    
    func action(_ on: HomeViewAction) {
        switch on {
        case .onAppear(let locale):
            self.start(locale: locale)
        case .onRefresh:
            self.refresh()
        case .onChangeSearch(let text):
            self.search(searchText: text)
        case .onChangeTrending:
            self.trending()
        }
    }
    
    private func start(locale: MovieDB.Locale? = nil) {
        if let locale = locale {
            self.locale = locale
        }
        if state == .empty || state == .error {
            self.state = .loading
            Task {
                do {
                    for section in MovieDB.homeSections {
                        let mediaSection = MediaSection(title: section.title,
                                                        items: try await self.fetchMediaUseCase.fetchMedia(type: section, locale: self.locale, searchText: nil).filterWithImage())
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
    
    private func clean() {
        self.mediaSectionsList.removeAll()
        self.mediaTrendingList.removeAll()
        self.mediaSearchList.removeAll()
        self.state = .empty
    }
    
    private func refresh() {
        if state != .loading {
            self.clean()
            self.start()
        }
    }
    
    private func trending() {
        Task {
            defer {
            }
            do {
                self.mediaSearchList = try await fetchMediaUseCase.fetchMedia(type: .trendingAll, locale: self.locale, searchText: nil).filterWithImage()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func search(searchText: String) {
        self.mediaSearchList.removeAll()
        Task {
            defer {
            }
            do {
                self.mediaSearchList = try await fetchMediaUseCase.fetchMedia(type: .searchAll, locale: self.locale, searchText: searchText).filterWithImage()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getOpenAIResponse() {
        Task {
            do {
                let _ = try await getOpenAIUseCase.getTextAnswer(prompt: "texto de prueba")
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getGeminiResponse(prompt: String) {
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
