//
//  HomeModelLogic.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Observation

@Observable
final class HomeModelLogic: EventHandler {
    
    // MARK: - Public Read-Only Properties
    private(set) var mediaSectionsList: [MediaSection] = []
    private(set) var mediaTrendingList: [Media] = []
    private(set) var mediaSearchList: [Media] = []
    private(set) var state: API.Status = .empty
    
    // MARK: - Private Properties
    @ObservationIgnored private var locale = MediaLocale()
    @ObservationIgnored private let mediaUseCase: MediaUseCaseProtocol
    
    // MARK: - Initialization
    init(mediaUseCase: MediaUseCaseProtocol = MediaUseCase()) {
        self.mediaUseCase = mediaUseCase
    }
    
    // MARK: - Event Handling
    enum Event {
        case viewAppear(MediaLocale),
             refreshData,
             reloadData(MediaLocale),
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
    private func start(locale: MediaLocale? = nil) {
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
    private func reload(locale: MediaLocale) {
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
                self.mediaSearchList = try await mediaUseCase.fetchTrendingMedia(locale: self.locale)
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
                self.mediaSearchList = try await mediaUseCase.fetchSearchMedia(locale: self.locale, searchText: searchText)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
