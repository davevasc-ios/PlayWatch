//
//  HomeMovieViewModel.swift
//  PlayWatch
//
//  Created by David on 1/4/24.
//

import Foundation
import Observation
import SwiftUI

@Observable final class HomeViewModel {

    var mediaSectionsList: [MediaSection] = []
    
//    var users: [User] = []
//    var status: ListStatus = .empty
    var errorMessage = "no working"
    
    // MARK: - Internal vars
    private let fetchMediaUseCase: FetchMediaProtocol
    private let getOpenAIUseCase: GetOpenAIResponseProtocol
    private let getGeminiUseCase: GetGeminiResponseProtocol

    // MARK: - Initialization
    init(
        //        users: [User] = [],
        //         status: ListStatus = .empty,
        //         errorMessage: String = "",
        fetchMediaUseCase: FetchMediaProtocol = FetchMediaUseCase(),
        getOpenAIUseCase: GetOpenAIResponseProtocol = GetOpenAIResponseUseCase(),
        getGeminiUseCase: GetGeminiResponseProtocol = GetGeminiResponseUseCase()) {
            
            
            //        self.users = users
            //        self.status = status
            //        self.errorMessage = errorMessage
            self.fetchMediaUseCase = fetchMediaUseCase
            self.getOpenAIUseCase = getOpenAIUseCase
            self.getGeminiUseCase = getGeminiUseCase
        }
    
    
    func start() async throws {
        do {
            for section in MovieDB.QueryType.allCases {
                let mediaSection = MediaSection(title: section.title,
                                                items: try await fetchMediaUseCase.fetchMedia(section: section))
                mediaSectionsList.append(mediaSection)
            }
        } catch {
            print(error)
        }
    }
    
    func getOpenAIResponse() async throws {
//        self.users = []
//        self.status = .loading
        do {
            self.errorMessage = try await getOpenAIUseCase.getResponse()
//            self.users = userListModel.results
//            self.status = self.users.isEmpty ? .empty : .success
        }
        catch {
//            self.status = .error
//            self.errorMessage = error.localizedDescription
//            throw error
        }
    }
    
    func getGeminiResponse() async throws {
        do {
            self.errorMessage = try await getGeminiUseCase.getResponse()
        }
        catch {
        }
    }
    
}
