//
//  OpenAISystemModel.swift
//  PlayWatch
//
//  Created by David on 16/2/25.
//

import Foundation

enum OpenAISystemMode: String {
    case json = "You are an assistant that only generates a valid JSON files. You will always return only a valid JSON file, don’t write nothing outside from JSON file.",
         translator = "You are an assistant that only translate one text in other. You will always return only a valid translated text, don’t write nothing outside from a valid translation text."
}
