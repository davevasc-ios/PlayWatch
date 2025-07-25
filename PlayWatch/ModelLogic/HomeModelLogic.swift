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
    @ObservationIgnored private let mediaUseCase: MediaUseCaseProtocol
    
    // MARK: - Initialization
    init(mediaUseCase: MediaUseCaseProtocol) {
        self.mediaUseCase = mediaUseCase
    }
    
    // MARK: - Event Handling
    enum Event {
        case viewAppear,
             refreshData,
             reloadData,
             changeSearch(String),
             changeTrending
    }
    
    // MARK: - Public Methods
    func on(_ event: Event) {
        switch event {
        case .viewAppear:
            self.start()
        case .refreshData:
            self.refresh()
        case .reloadData:
            self.reload()
        case .changeSearch(let text):
            self.search(searchText: text)
        case .changeTrending:
            self.trending()
        }
    }
    
    // MARK: - Private Methods
    @MainActor
    private func start() {
        if state == .empty || state == .error {
            self.state = .loading
            Task {
                do {
                    self.mediaSectionsList = try await self.mediaUseCase.fetchMediaSections()
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
    private func reload() {
        if state != .loading {
            self.clean()
            self.start()
        }
    }
    
    @MainActor
    private func trending() {
        Task {
            defer {
            }
            do {
                self.mediaSearchList = try await mediaUseCase.fetchTrendingMedia()
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
                self.mediaSearchList = try await mediaUseCase.fetchSearchMedia(searchText: searchText)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
