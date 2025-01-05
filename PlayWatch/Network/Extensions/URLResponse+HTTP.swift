//
//  URLResponse+HTTP.swift
//  PlayWatch
//
//  Created by David on 15/12/24.
//

import Foundation

extension URLResponse {
    var asHTTPURLResponse: HTTPURLResponse? {
        return self as? HTTPURLResponse
    }
}
