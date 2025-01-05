//
//  Bundle+Extensions.swift
//  PlayWatch
//
//  Created by David on 4/1/25.
//

import Foundation

extension Bundle {
    func jsonURLRequest(for resource: String) throws -> URLRequest {
        guard let url = self.url(forResource: resource, withExtension: Constants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
