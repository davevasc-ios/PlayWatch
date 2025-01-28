//
//  Constants.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

struct Constants {
    
    enum DateFormatType: String {
        case repository = "yyyy-MM-dd"
        case display = "dd/MM/yyyy"
    }
       
    static let homeSections: [MediaFetchType] = [
        .randomMovies,
        .cinemaPlaying,
        .cinemaUpcomimg,
        .movieTrending,
        .movieNew,
        .tvTrending,
        .tvNew,
        .personTrending,
        .personPopular
    ]
    
    enum AIServer: String, CaseIterable, Identifiable {
        
        case openAI = "OpenAI"
        case gemini = "Gemini"
        
        var id: Self { self }
        
        var testResource: String {
            switch self {
            case .openAI: Constants.Resource.Name.openAIResponse
            case .gemini: Constants.Resource.Name.geminiAIResponse
            }
        }
        
        func decodeQuizResponse(from data: Data) throws -> String {
            switch self {
            case .openAI: try OpenAIResponse.decode(from: data).aiResponseText
            case .gemini: try GeminiResponse.decode(from: data).aiResponseText
            }
        }
    }
    
    enum Game {
        
        static let screenCutoffScale: CGFloat = 0.8 / 2
        static let questionHeightScale: CGFloat = 0.15
        static let quizWidhtScale: CGFloat = 0.65
        static let quizCardDegrees: CGFloat = 12
        static let typingTextIntervales: [UInt64] = [10000000, 40000000, 80000000, 160000000, 200000000]
        static let swipeDownDegrees: [Double] = [-30, -20, -10, 0, 10, 20, 30]
        static let numberOfQuizzes = 20
        static let secondsPerQuiz = 6
        
        enum Error: LocalizedError {
            
            case outOfRange
            
            var errorDescription: String? {
                switch self {
                case .outOfRange:
                    return "Data is out of range"
                }
            }
        }
    }
    
    enum Resource {
        
        enum Name {
            
            static let all = "All"
            static let movies = "Movies"
            static let people = "People"
            static let tvShows = "TVShows"
            static let openAIResponse = "OpenAIResponse"
            static let geminiAIResponse = "GeminiAIResponse"
        }
        
        enum Extension {
            
            static let json = "json"
        }
    }
    
    static func quizPrompt(_ movies: String, _ language: String) -> String {
"""
Give me a just a valid JSON Array of following structure, each one, about one of these movies (no 'movies' field, no 'data' field, just array): \(movies).

Field 1: 'question' (String), a very difficult and original question whose answer is true or false (Ensure that the number of true answers is roughly equal to the number of false answers), about the corresponding movie, in '\(language)' language
Field 2: 'result' (Boolean), the answer of the previous question, which can only be true or false
"""
    }
}








