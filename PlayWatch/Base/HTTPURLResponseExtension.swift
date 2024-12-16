//
//  HTTPURLResponseExtension.swift
//  PlayWatch
//
//  Created by David on 15/12/24.
//

import Foundation

extension HTTPURLResponse {
    var isSuccess: Bool {
        return self.statusCode == HTTP.successCode
    }
}
