//
//  LocalizableAccount.swift
//  PlayWatch
//
//  Created by David on 22/11/25.
//

import Foundation

extension Localizable {
    
    // MARK: - Table LocalizableAccount
    enum Account {
        
        static let title = LocalizedStringResource(
            "account.section.title",
            defaultValue: "Account",
            table: "LocalizableAccount",
            comment: "Account section title"
        )
    }
}
