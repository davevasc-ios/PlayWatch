//
//  OpenAIModel.swift
//  PlayWatch
//
//  Created by David on 16/2/25.
//

import Foundation

enum OpenAIModel: String, Codable, OpenAIModelCompatible {
    case gpt3 = "gpt-3.5-turbo"
    case gpt4o = "gpt-4o"
    case o1 = "o1"
    case o1Mini = "o1-mini"
    case o3Mini = "o3-mini"
    
    var model: OpenAIModel { self }
}
