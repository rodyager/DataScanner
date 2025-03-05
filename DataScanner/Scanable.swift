//
//  Scanable.swift
//  DataScanner
//
//  Created by Rod Yager on 4/3/2025.
//

import VisionKit

/// Adoption of this protocol enables Camea data entry  using a ``DataButton``
protocol Scanable {
    
    /// sets the value using the string detected by the Camera..
    /// - Parameters:
    ///   - from: The scanned string.
    mutating func value(from: String)
    
    /// determines the categories of objects the Camera will detect
    /// - Returns: A `Set` of Recognized Data Types
    func recognizedDataTypes() -> Set<DataScannerViewController.RecognizedDataType>
    
    /// determines how the value detedted by the Camera will be represented to the user
    /// - Returns: A suitably formatted string representing the detected value
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
    func recognizedDataTypes() -> Set<DataScannerViewController.RecognizedDataType> {
         [.text(textContentType: .dateTimeDuration)]
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
    func recognizedDataTypes() -> Set<DataScannerViewController.RecognizedDataType> {
        [.text(textContentType: .currency)]
    }
    func scanFormatted() -> String {
        NumberFormatter.currency.string(from: (self as NSNumber) ) ?? ""
    }
}
