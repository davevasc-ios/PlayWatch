//
//  OpenAIModelCompatible.swift
//  PlayWatch
//
//  Created by David on 16/2/25.
//

import Foundation

protocol OpenAIModelCompatible {
    
    associatedtype ModelType: RawRepresentable & Codable where ModelType.RawValue == String
    var model: ModelType { get }
}
