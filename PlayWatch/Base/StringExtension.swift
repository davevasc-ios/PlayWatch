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
    var orEmpty: String { self ?? "" }
}

extension String {
    static var empty: String {
        return ""
    }
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
        guard let emailPattern = try? Regex("[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Z]{2,6}") else { return false }
        return self.wholeMatch(of: emailPattern) != nil
    }
}
