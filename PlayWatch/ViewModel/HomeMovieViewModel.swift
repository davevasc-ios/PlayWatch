//
//  HomeMovieViewModel.swift
//  PlayWatch
//
//  Created by David on 1/4/24.
//

import Foundation
import Observation
import SwiftUI

@Observable final class HomeMovieViewModel {
    
//    var users: [User] = []
//    var status: ListStatus = .empty
    var errorMessage = "no working"
    
    // MARK: - Internal vars
    private let fetchTrendUseCase: FetchTrendProtocol
    private let fetchCinemaUseCase: FetchCinemaProtocol


    // MARK: - Initialization
    init(
        //        users: [User] = [],
        //         status: ListStatus = .empty,
        //         errorMessage: String = "",
        fetchTrendUseCase: FetchTrendProtocol = FetchTrendUseCase(),
        fetchCinemaUseCase: FetchCinemaProtocol = FetchCinemaUseCase()) {
            self.fetchTrendUseCase = fetchTrendUseCase
            
            
            //        self.users = users
            //        self.status = status
            //        self.errorMessage = errorMessage
            self.fetchCinemaUseCase = fetchCinemaUseCase
            
        }
    
    func fetchTrend() async throws {
//        self.users = []
//        self.status = .loading
        do {
            self.errorMessage = try await fetchTrendUseCase.fetchTrend()
//            self.users = userListModel.results
//            self.status = self.users.isEmpty ? .empty : .success
        }
        catch {
//            self.status = .error
//            self.errorMessage = error.localizedDescription
//            throw error
        }
    }
    
    func fetchCinema() async throws {
//        self.users = []
//        self.status = .loading
        do {
            self.errorMessage = try await fetchCinemaUseCase.fetchCinema()
//            self.users = userListModel.results
//            self.status = self.users.isEmpty ? .empty : .success
        }
        catch {
//            self.status = .error
//            self.errorMessage = error.localizedDescription
//            throw error
        }
    }
}
