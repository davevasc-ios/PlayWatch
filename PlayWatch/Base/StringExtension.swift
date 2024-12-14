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
    var orEmpty: String { self ?? .empty }
}

extension String {
    static var empty: String { "" }
    static var commaSeparator: String { ", " }
    
    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var isEmpty: Bool {
        self.trim() == .empty
    }
    var ifNotEmpty: String? {
        self.isEmpty ? nil : self
    }
    func removeCharacters(from: Set<Character>) -> String {
        self.filter { !from.contains($0) }
    }
    var isValidEmail: Bool {
        guard let emailPattern = try? Regex("[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Z]{2,6}") else { return false }
        return self.wholeMatch(of: emailPattern) != nil
    }
    func toUTF8Data() throws -> Data {
        guard let data = self.data(using: .utf8) else {
            throw API.Error.invalidData(detail: self)
        }
        return data
    }
}
