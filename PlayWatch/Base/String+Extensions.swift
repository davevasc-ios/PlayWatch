//
//  String+Extensions.swift
//  PlayWatch
//
//  Created by David on 13/4/24.
//

import Foundation

// MARK: - String Constants
extension String {
    static let empty = ""
    static let commaSeparator = ", "
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
}

// MARK: - String Utility Extensions
extension String {
    // MARK: - Properties
    var isTrimmedEmpty: Bool { self.trim() == .empty }
    var isNotEmpty: Bool { !self.isTrimmedEmpty }
    var ifNotEmpty: String? { self.isTrimmedEmpty ? nil : self }
    
    // MARK: - Methods
    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func removeCharacters(from charactersToRemove: Set<Character>) -> String {
        self.filter { !charactersToRemove.contains($0) }
    }
}

// MARK: - String Validation
extension String {
    var isValidEmail: Bool {
        guard let emailPattern = try? Regex(Self.emailRegex) else { return false }
        return self.wholeMatch(of: emailPattern) != nil
    }
}

// MARK: - String Data Conversion
extension String {
    func toUTF8Data() throws -> Data {
        guard let data = self.data(using: .utf8) else {
            throw String.Error.invalidUTF8Conversion(string: self)
        }
        return data
    }
}

// MARK: - Optional String Extensions
extension Optional where Wrapped == String {
    var isNil: Bool { self == nil }
    var isNotNil: Bool { self != nil }
    var orEmpty: String { self ?? .empty }
}
