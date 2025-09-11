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
//    private(set) var mediaTrendingList: [Media] = []
    private(set) var mediaSearchList: [Media] = []
    private(set) var state: API.Status = .empty
    
    // MARK: - Private Properties
    @ObservationIgnored private let movieDBUtility: MediaUtilityProtocol

    
    // MARK: - Initialization
    init(
        movieDBUtility: MediaUtilityProtocol
    ) {
        self.movieDBUtility = movieDBUtility
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
                    let sections = try await self.movieDBUtility.fetchMediaSections(sections: Constants.homeSections)
                    self.mediaSectionsList = sections
                    self.state = .success
                } catch {
                    print(error.localizedDescription)
                    self.state = .error
                }
            }
        }
    }
    
//    @MainActor
//    nonisolated func fetchMediaSections() async throws -> [MediaSection] {
//        let mediaLocale = try await self.storageUtility.loadMediaLocale()
//        return try await withThrowingTaskGroup(of: (Int, MediaSection).self) { group in
//            for (index, section) in Constants.homeSections.enumerated() {
//                group.addTask {
//                    let config = MediaRequestConfig(mediaType: section, locale: mediaLocale)
//                    let mediaItems = try await self.movieDBUtility.fetchMedia(config: config)
//                    return (index, MediaSection(title: section.localized, items: mediaItems))
//                }
//            }
//            return try await group.reduce(into: []) { $0.append($1) }
//        }.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
//    }
    
//    // MARK: - Private Methods
//    @MainActor
//    private func start() {
//        if state == .empty || state == .error {
//            self.state = .loading
//            Task {
//                do {
//                    self.mediaSectionsList = try await self.mediaUseCase.fetchMediaSections()
//                    self.state = .success
//                } catch {
//                    print(error.localizedDescription)
//                    self.state = .error
//                }
//            }
//        }
//    }
    
    private func clean() {
        self.mediaSectionsList.removeAll()
//        self.mediaTrendingList.removeAll()
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
                self.mediaSearchList = try await movieDBUtility.fetchMedia(mediaType: .trendingAll)
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
                self.mediaSearchList = try await movieDBUtility.fetchMedia(mediaType: .searchAll, searchQuery: searchText)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
