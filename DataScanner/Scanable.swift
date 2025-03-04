//
//  Scanable.swift
//  DataScanner
//
//  Created by Rod Yager on 4/3/2025.
//

import VisionKit

protocol Scanable {
    mutating func value(from: String)
    func contentTypes( ) -> [DataScannerViewController.RecognizedDataType]
    func scanFormatted() -> String
}

extension Date: Scanable {
    mutating func value(from string: String)  {
        if let detector =  try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue){
            let matches = detector.matches(in: string, options: [], range: NSRange(string.startIndex..., in: string))
            if  let date = matches.first?.date {
                self = date
            }
        }
    }
    func contentTypes( ) -> [DataScannerViewController.RecognizedDataType] {
        return [.text(textContentType: .dateTimeDuration)]
    }
    func scanFormatted() -> String {
        DateFormatter.mediumDate.string(from: self)
    }
}

extension Double: Scanable {
    mutating func value(from string: String) {
        if let value = NumberFormatter.currency.number(from: string) {
            self = value.doubleValue
        }
    }
    func contentTypes( ) -> [DataScannerViewController.RecognizedDataType] {
        return [.text(textContentType: .currency)]
    }
    func scanFormatted() -> String {
        NumberFormatter.currency.string(from: (self as NSNumber) ) ?? ""
    }
}
