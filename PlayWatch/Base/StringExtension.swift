//
//  StringExtension.swift
//  PlayWatch
//
//  Created by David on 13/4/24.
//

import Foundation

extension Optional where Wrapped == String {
    var isNil: Bool { self == nil }
    var isNotNil: Bool { self != nil }
    var isEmpty: Bool { self?.isEmpty ?? true }
    var isValue: Bool { !self.isEmpty }
    var getValue: String { self ?? "" }
}

extension String {
    var isEmpty: Bool {
        self.trim() == ""
    }
    var isValue: Bool {
        !self.isEmpty
    }
    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func removeCharacters(from: Set<Character>) -> String {
        self.filter { !from.contains($0) }
    }
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }
    var toDate: Date? {
        var date = Date()
        return date
    }
}
