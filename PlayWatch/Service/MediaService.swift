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
    case loaded([MediaSection], AppLanguage)
    case failure(Error)
}

@Observable
final class MediaService: EventHandler {
    
    // MARK: - Public Read-Only Properties
    private(set) var homeState: HomeState = .empty
//    private(set) var mediaTrendingList: [Media] = []
    private(set) var mediaSearchList: [Media] = []
    
    // MARK: - Private Properties
    @ObservationIgnored private let movieDBUtility: MediaUtilityProtocol
    @ObservationIgnored private let preferencesService: PreferencesService // 2. El servicio ahora conoce las preferencias.

    
    // MARK: - Initialization
    init(
        movieDBUtility: MediaUtilityProtocol,
        preferencesService: PreferencesService
    ) {
        self.movieDBUtility = movieDBUtility
        self.preferencesService = preferencesService
        
    }
    
    // MARK: - Event Handling
    enum Event {
        case viewAppear,
             refreshData,
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
        case .loaded(_, let loadedLanguage) where loadedLanguage == preferencesService.selectedLanguage:
            print("Datos ya cargados para el idioma actual. No se necesita recargar.")
            return
        default:
            print("Iniciando carga de datos...")
            self.homeState = .loading
            Task {
                do {
                    let sections = try await self.movieDBUtility.fetchMediaSections(sections: Constants.homeSections)
                    self.homeState = sections.isEmpty ? .empty : .loaded(sections, preferencesService.selectedLanguage)
                } catch {
                    print(error.localizedDescription)
                    self.homeState = .failure(error)
                }
            }
        }
    }
    

    
    private func clean() {
        self.homeState = .empty
        self.mediaSearchList.removeAll()
    }
    
    @MainActor
    private func refresh() {
        switch homeState {
        case .loading:
            break
        default:
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

