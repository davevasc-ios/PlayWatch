//
//  MediaService.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Foundation
import Observation

enum Loadable<Value: Sendable>: Sendable {
    case idle
    case loading
    case success(Value)
    case failure(Error)
    
    var isLoading: Bool {
         switch self {
         case .loading: true
         default: false
         }
     }
    
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
    @ObservationIgnored private let mediaRepository: MediaRepositoryProtocol
    @ObservationIgnored private let localeProvider: MediaLocaleProvider
    
    // MARK: - Initialization
    init(
        mediaRepository: MediaRepositoryProtocol,
        mediaLocaleProvider: MediaLocaleProvider
    ) {
        self.mediaRepository = mediaRepository
        self.localeProvider = mediaLocaleProvider
    }
    
    // MARK: - Event Handling
    enum Event {
        case loadData,
             slideToRefresh,
             changeSearch(String),
             changeTrending
    }
    
    // MARK: - Public Methods
    func on(_ event: Event) async {
        switch event {
        case .loadData:
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
        case .success(let homeContent) where homeContent.locale == localeProvider.mediaLocale:
            print("ℹ️ Datos ya cargados para el idioma actual (\(localeProvider.mediaLocale.language)). No se necesita recargar.")
            return
        default:
            print("⏳ Iniciando carga de datos para nuevo idioma (\(localeProvider.mediaLocale.language))")
            self.homeState = .loading
            do {
//                try await Task.sleep(nanoseconds: 3_000_000_000)
                let sections = try await self.mediaRepository.fetchMediaSections(for: Constants.homeSections, with: localeProvider.mediaLocale)
                let homeContent = HomeContent(sections: sections, locale: localeProvider.mediaLocale)
                self.homeState = .success(homeContent)
                print("✅ Finalizada la carga de datos para nuevo idioma (\(localeProvider.mediaLocale.language))")
            } catch let error as CancellationError {
                print("⛔️ Tarea cancelada. Error: \(error.localizedDescription)")
                self.homeState = .failure(error)
            } catch let error as URLError where error.code == .cancelled {
                print("❌ Petición de red cancelada. Error: \(error.localizedDescription)")
                self.homeState = .failure(error)
            } catch {
                print("💥 Fallo durante la carga de datos para nuevo idioma (\(localeProvider.mediaLocale.language)). Error: \(error.localizedDescription)")
                self.homeState = .failure(error)
            }
        }
    }
    
    private func refresh() async {
        guard !homeState.isLoading else { return }
        self.homeState = .idle
        await self.start()
    }
    
    
    private func trending() async {
        do {
            self.mediaSearchList = try await mediaRepository.fetchMedia(for: .trendingAll, with: localeProvider.mediaLocale, searchQuery: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func search(searchText: String) async {
        self.mediaSearchList.removeAll()
        do {
            self.mediaSearchList = try await mediaRepository.fetchMedia(for: .searchAll, with: localeProvider.mediaLocale, searchQuery: searchText)
        } catch {
            print(error.localizedDescription)
        }
    }
}

