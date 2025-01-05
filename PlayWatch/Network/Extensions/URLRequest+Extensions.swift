//
//  URLRequest+Extensions.swift
//  PlayWatch
//
//  Created by David on 4/1/25.
//

import Foundation

extension URLRequest {
    func fetchData(using session: URLSession = .shared) async throws -> Data {
        if let url = self.url,
           url.isFileURL {
            return try url.toData()
        }
        let (data, response) = try await session.data(for: self)
        guard let httpResponse = response.asHTTPURLResponse,
              httpResponse.isSuccess else {
            throw API.Error.invalidResponse(detail: data.toUTF8String)
        }
        return data
    }
}
