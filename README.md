This is a simple project to demonstrate the SwiftUI `DataButton` struct and a `Scanable` protocol.

`DataButton($scanable)`  provides a button to enable the camera to capture of value of `scanable` provided scanable conforms to the
`Scanable` protocol.

Sample implementations are provided to make `Date` and `Double` conform to the `Scanable`   protocol to scan dates and currency respectively.

The `Scanable` protocol requires three functions:

`mutating func value(from: String)`  to transform the value of the `Scanable` to reflect the detected text.

`func recognizedDataTypes() -> Set<DataScannerViewController.RecognizedDataType>` to specify the kind of text or barcode that is to be detected and

`func scanFormatted() -> String ` to provide a textual representation of the detected value for the user.
