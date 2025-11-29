//
//  MediaService.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Observation

enum Loadable<Value: Sendable>: Sendable {
    case idle
    case loading
    case success(Value)
    case failure(Error)
    
    var value: Value? {
        switch self {
        case .success(let value): value
        default: nil
        }
    }
}

struct HomeContent: Sendable {
    let sections: [MediaSection]
    let locale: MediaLocale
    
    var isEmpty: Bool {
        sections.isEmpty
    }
}

@Observable
final class MediaService: EventHandler {
    
    // MARK: - Public Read-Only Properties
    private(set) var homeState: Loadable<HomeContent> = .idle
    private(set) var mediaSearchList: [Media] = []
    
    // MARK: - Private Properties
    @ObservationIgnored private let movieDBUtility: MediaRopositoryProtocol
    @ObservationIgnored private let mediaLocaleProvider: MediaLocaleProvider
    
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
    func on(_ event: Event) async {
        switch event {
        case .viewAppear:
            await self.start()
        case .slideToRefresh:
            await self.refresh()
        case .changeSearch(let text):
            await self.search(searchText: text)
        case .changeTrending:
            await self.trending()
        }
    }
    
    // MARK: - Private Methods
    
    private func start() async {
        switch homeState {
        case .loading:
            print("ℹ️ Ya está en proceso de carga. No se inicia una nueva petición.")
            return
        case .success(let homeContent) where homeContent.locale == mediaLocaleProvider.mediaLocale:
            print("ℹ️ Datos ya cargados para el idioma actual (\(mediaLocaleProvider.mediaLocale.language)). No se necesita recargar.")
            return
        default:
            print("⏳ Iniciando carga de datos para nuevo idioma (\(mediaLocaleProvider.mediaLocale.language))")
            self.homeState = .loading
            do {
                let sections = try await self.movieDBUtility.fetchMediaSections(for: Constants.homeSections, with: mediaLocaleProvider.mediaLocale)
                let homeContent = HomeContent(sections: sections, locale: mediaLocaleProvider.mediaLocale)
                self.homeState = sections.isEmpty ? .idle : .success(homeContent)
                print("✅ Finalizada la carga de datos para nuevo idioma (\(mediaLocaleProvider.mediaLocale.language))")
            } catch {
                print("💥 Fallo durante la carga de datos para nuevo idioma (\(mediaLocaleProvider.mediaLocale.language)). Error: \(error.localizedDescription)")
                print(error.localizedDescription)
                self.homeState = .failure(error)
            }
        }
    }
    
    private func refresh() async {
        switch homeState {
        case .loading:
            break
        default:
            self.homeState = .idle
            await self.start()
        }
    }
    
    
    private func trending() async {
        do {
            self.mediaSearchList = try await movieDBUtility.fetchMedia(for: .trendingAll, with: mediaLocaleProvider.mediaLocale)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func search(searchText: String) async {
        self.mediaSearchList.removeAll()
        do {
            self.mediaSearchList = try await movieDBUtility.fetchMedia(for: .searchAll, with: mediaLocaleProvider.mediaLocale, searchQuery: searchText)
        } catch {
            print(error.localizedDescription)
        }
    }
}

