//
//  fetchTrendUseCase.swift
//  PlayWatch
//
//  Created by David on 4/4/24.
//

import Foundation

protocol FetchTrendProtocol {
    func fetchTrend() async throws -> String
}
struct FetchTrendUseCase: FetchTrendProtocol {
    var service: MovieDBServiceProtocol
    
    init(service: MovieDBServiceProtocol = MovieDBService()) {
        self.service = service
    }
    
    func fetchTrend() async throws -> String {
        let query = MdbAPI.QueryData(mode: .cinema, media: .movie, period: .week, provider: .netflix, query: "")
        let x = try await service.fetchTrend(query: query)
        for i in x {
            print("TITULO Trend: \(i.title ?? "no title")")
        }
        return "ok from Trend user case"
    }
}
