//
//  HomeMovieViewModel.swift
//  PlayWatch
//
//  Created by David on 1/4/24.
//

import Observation

@Observable
final class HomeViewModel: EventHandler {
    
    // MARK: - Public Read-Only Properties
    private(set) var mediaSectionsList: [MediaSection] = []
    private(set) var mediaTrendingList: [Media] = []
    private(set) var mediaSearchList: [Media] = []
    private(set) var state: API.Status = .empty
    
    // MARK: - Private Properties
    @ObservationIgnored private var locale = MovieDB.Locale()
    @ObservationIgnored private let getOpenAIUseCase: GetOpenAIResponseProtocol
    @ObservationIgnored private let getGeminiUseCase: GetGeminiResponseProtocol
    @ObservationIgnored private let mediaUseCase: MediaUseCaseProtocol
    
    // MARK: - Initialization
    init(
        getOpenAIUseCase: GetOpenAIResponseProtocol = GetOpenAIResponseUseCase(),
        getGeminiUseCase: GetGeminiResponseProtocol = GetGeminiResponseUseCase(),
        mediaUseCase: MediaUseCaseProtocol = MediaUseCase()
    ) {
        // TODO: Remove all of fetchMediUseCase
        self.getOpenAIUseCase = getOpenAIUseCase
        self.getGeminiUseCase = getGeminiUseCase
        self.mediaUseCase = mediaUseCase
    }
    
    // MARK: - Event Handling
    enum Event {
        case viewAppear(MovieDB.Locale),
             refreshData,
             reloadData(MovieDB.Locale),
             changeSearch(String),
             changeTrending
    }
    
    // MARK: - Public Methods
    func on(_ event: Event) {
        switch event {
        case .viewAppear(let locale):
            self.start(locale: locale)
        case .refreshData:
            self.refresh()
        case .reloadData(let locale):
            self.reload(locale: locale)
        case .changeSearch(let text):
            self.search(searchText: text)
        case .changeTrending:
            self.trending()
        }
    }
    
    // MARK: - Private Methods
    @MainActor
    private func start(locale: MovieDB.Locale? = nil) {
        if let locale = locale {
            self.locale = locale
        }
        if state == .empty || state == .error {
            self.state = .loading
            Task {
                do {
                    self.mediaSectionsList = try await self.mediaUseCase.fetchMediaSections(locale: self.locale)
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
    
    @MainActor
    private func refresh() {
        if state != .loading {
            self.clean()
            self.start()
        }
    }
    
    @MainActor
    private func reload(locale: MovieDB.Locale) {
        if state != .loading {
            self.clean()
            self.start(locale: locale)
        }
    }
    
    @MainActor
    private func trending() {
        Task {
            defer {
            }
            do {
                self.mediaSearchList = try await mediaUseCase.fetchMedia(for: .trendingAll, locale: self.locale)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    private func search(searchText: String) {
        self.mediaSearchList.removeAll()
        Task {
            defer {
            }
            do {
                self.mediaSearchList = try await mediaUseCase.fetchMediaSearch(for: .searchAll, locale: self.locale, searchText: searchText)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    private func getOpenAIResponse() {
        Task {
            do {
                let _ = try await self.getOpenAIUseCase.getTextAnswer(prompt: "texto de prueba")
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func getGeminiResponse(prompt: String) {
        Task {
            do {
                let result = try await self.getGeminiUseCase.getResponse(prompt: prompt)
                print(result)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
