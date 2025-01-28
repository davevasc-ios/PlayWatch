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
    var headers: [HTTP.Header.Field: HTTP.Header.Value] { get }
}
