//
//  DeepSeekModel.swift
//  PlayWatch
//
//  Created by David on 16/2/25.
//

import Foundation

enum DeepSeekModel: String, Codable, OpenAIModelCompatible {
    case chat = "deepseek-chat"
    case reasoner = "deepseek-reasoner"
    
    var model: DeepSeekModel { self }
}
