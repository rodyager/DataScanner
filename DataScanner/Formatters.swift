//
//  Formatters.swift
//  DataScanner
//
//  Created by Rod Yager on 4/3/2025.
//

import Foundation

extension DateFormatter {
    /// static formatter for dd MM yyyy style dates
    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_AU")
        return formatter
    }()
}

extension NumberFormatter {
    /// static formatter for the numerical part of currency
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.isLenient = true
        return formatter
    }()
}
