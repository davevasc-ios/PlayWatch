//
//  Date+Extensions.swift
//  PlayWatch
//
//  Created by David on 21/4/24.
//

import Foundation

extension Date {
    func toString(daysOffset: Int = 0, format formatType: Constants.DateFormatType = .repository) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.rawValue
        guard let modifiedDate = Calendar.current.date(byAdding: .day, value: daysOffset, to: self) else {
            return .empty
        }
        return dateFormatter.string(from: modifiedDate)
    }
}
