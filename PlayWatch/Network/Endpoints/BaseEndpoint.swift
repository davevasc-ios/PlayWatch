//
//  BaseEndpoint.swift
//  PlayWatch
//
//  Created by David on 27/1/25.
//

import Foundation

protocol BaseEndpointProtocol: Sendable {
    var baseURL: String { get }
    var method: HTTP.Method { get }
    var apiKey: API.Key { get }
    var headers: [HTTP.Header.Field: HTTP.Header.Value] { get }
    var timeout: TimeInterval { get }
}
