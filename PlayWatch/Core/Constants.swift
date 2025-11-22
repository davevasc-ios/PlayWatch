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
    
//    enum SheetID {
//        static let account = "accountSheet"
//        static let language = "languageSheet"
//    }
}
