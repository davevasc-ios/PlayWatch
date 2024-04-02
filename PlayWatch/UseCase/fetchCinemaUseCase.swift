//
//  fetchCinemaUseCase.swift
//  PlayWatch
//
//  Created by David on 1/4/24.
//

import Foundation

protocol FetchCinemaProtocol {
    func fetchCinema() async throws -> String
}
struct FetchCinemaUseCase: FetchCinemaProtocol {
    var service: MovieDBServiceProtocol
    
    init(service: MovieDBServiceProtocol = MovieDBService()) {
        self.service = service
    }
    
    func fetchCinema() async throws -> String {
        let x = try await service.fetchCinema()
        for i in x {
            print("TITULO: \(i.title)")
        }
        return "ok"
    }
}
