//
//  MediaService.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Observation

enum HomeState {
    case empty
    case loading
    case loaded([MediaSection], MediaLocale)
    case failure(Error)
    
    var loadedLanguageCode: String? {
        guard case .loaded(_, let language) = self else {
            return nil
        }
        return language.code.uppercased()
    }
}

@Observable
final class MediaService: EventHandler {
    
    // MARK: - Public Read-Only Properties
    private(set) var homeState: HomeState = .empty
    private(set) var mediaSearchList: [Media] = []
    
    // MARK: - Private Properties
    @ObservationIgnored private let movieDBUtility: MediaRopositoryProtocol
    @ObservationIgnored private let mediaLocaleProvider: MediaLocaleProvider
    
    var loadedLanguage: String {
        if case .loaded(_, let language) = homeState {
            return language.code.uppercased()
        }
        return .empty
    }
    
    // MARK: - Initialization
    init(
        movieDBUtility: MediaRopositoryProtocol,
        mediaLocaleProvider: MediaLocaleProvider
    ) {
        self.movieDBUtility = movieDBUtility
        self.mediaLocaleProvider = mediaLocaleProvider
    }
    
    // MARK: - Event Handling
    enum Event {
        case viewAppear,
             slideToRefresh,
             changeSearch(String),
             changeTrending
    }
    
    // MARK: - Public Methods
    func on(_ event: Event) {
        switch event {
        case .viewAppear:
            self.start()
        case .slideToRefresh:
            self.refresh()
        case .changeSearch(let text):
            self.search(searchText: text)
        case .changeTrending:
            self.trending()
        }
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func start() {
        switch homeState {
        case .loading:
            print("Ya está en proceso de carga. No se inicia una nueva petición.")
            return
        case .loaded(_, let loadedLanguage) where loadedLanguage.code == mediaLocaleProvider.mediaLocale.code:
            print("Datos ya cargados para el idioma actual (\(mediaLocaleProvider.mediaLocale.language)). No se necesita recargar.")
            return
        default:
            print("Iniciando carga de datos para nuevo idioma (\(mediaLocaleProvider.mediaLocale.language))")
            self.homeState = .loading
            Task {
                do {
                    // TODO: - habría que devolver el lenguaje, eso si.
                    let sections = try await self.movieDBUtility.fetchMediaSections(for: Constants.homeSections, with: mediaLocaleProvider.mediaLocale)
                    self.homeState = sections.isEmpty ? .empty : .loaded(sections, mediaLocaleProvider.mediaLocale)
                } catch {
                    print(error.localizedDescription)
                    self.homeState = .failure(error)
                }
            }
        }
    }
    

    @MainActor
    private func refresh() {
        switch homeState {
        case .loading:
            break
        default:
            self.homeState = .empty
            self.start()
        }
    }
    
    
    @MainActor
    private func trending() {
        Task {
            defer {
            }
            do {
                self.mediaSearchList = try await movieDBUtility.fetchMedia(for: .trendingAll, with: mediaLocaleProvider.mediaLocale)
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
                self.mediaSearchList = try await movieDBUtility.fetchMedia(for: .searchAll, with: mediaLocaleProvider.mediaLocale, searchQuery: searchText)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

