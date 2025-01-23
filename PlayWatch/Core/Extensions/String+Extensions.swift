//
//  String+Extensions.swift
//  PlayWatch
//
//  Created by David on 13/4/24.
//

import Foundation

// MARK: - Constants
extension String {
    static let empty = ""
    static let commaSeparator = ", "
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
}

// MARK: - Utility Extensions
extension String {
    // MARK: - Properties
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    var isTrimmedEmpty: Bool { self.trimmed.isEmpty }
    var isNotEmpty: Bool { !self.isTrimmedEmpty }
    var ifNotEmpty: String? { self.isTrimmedEmpty ? nil : self }
    
    // MARK: - Methods
    func removeCharacters(from charactersToRemove: Set<Character>) -> String {
        self.filter { !charactersToRemove.contains($0) }
    }
}

// MARK: - Validation
extension String {
    var isValidEmail: Bool {
        guard let emailPattern = try? Regex(Self.emailRegex) else { return false }
        return wholeMatch(of: emailPattern) != nil
    }
}

// MARK: - Data Conversion
extension String {
    func toUTF8Data() throws -> Data {
        guard let data = self.data(using: .utf8) else {
            throw String.Error.invalidUTF8Conversion(string: self)
        }
        return data
    }
}

// MARK: - Date Conversion
extension String {
    func toDate(format: Constants.DateFormatType = .repository) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.date(from: self)
    }
}

// MARK: - Optional Extensions
extension Optional where Wrapped == String {
    var isNil: Bool { self == nil }
    var isNotNil: Bool { self != nil }
    var orEmpty: String { self ?? String.empty }
}

// MARK: - LocalizedStringResource
extension LocalizedStringResource {
    static let empty: LocalizedStringResource = ""
}
