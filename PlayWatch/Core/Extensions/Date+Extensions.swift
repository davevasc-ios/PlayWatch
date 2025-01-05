//
//  Date+Extensions.swift
//  PlayWatch
//
//  Created by David on 21/4/24.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: self)
    }
}
