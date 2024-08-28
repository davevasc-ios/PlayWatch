//
//  URLSessionExtension.swift
//  PlayWatch
//
//  Created by David on 18/8/24.
//

import Foundation

extension URLSession {
    func data(request: URLRequest) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(for: request, delegate: nil)
    }
}
