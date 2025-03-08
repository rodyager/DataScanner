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

struct Currency: Codable  {
    var value: Double = 0
    
    init(_ value: Double = 0) {
        self.value = value
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(Double.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

extension Currency: Scanable {
    mutating func value(from string: String) {
        if let value = NumberFormatter.currency.number(from: string) {
            self.value = value.doubleValue
        }
    }
    func recognizedDataTypes() -> Set<DataScannerViewController.RecognizedDataType> {
        [.text(textContentType: .currency)]
    }
    func scanFormatted() -> String {
        NumberFormatter.currency.string(from: (value as NSNumber) ) ?? ""
    }
}


extension URL: Scanable {
    mutating func value(from string: String) {
        if let value = URL(string: string) {
            self = value
        }
    }
    func recognizedDataTypes() -> Set<DataScannerViewController.RecognizedDataType> {
        [.text(textContentType: .URL), .barcode()]
    }
    func scanFormatted() -> String {
        self.absoluteString
    }
}
