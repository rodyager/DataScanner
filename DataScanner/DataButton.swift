//
//  DataButton.swift
//  DataScanner
//
//  Created by Rod Yager on 4/3/2025.
//

import SwiftUI
import VisionKit

struct DataButton<T>: View  where T: Scanable {
    @Binding var value: T
    @State private var presenting = false
    /// internal copy of the ``Scanable`` value for use during scanning
    @State private var scannedValue: T
    
    init(_ boundValue: Binding<T>) {
        _value = boundValue
        scannedValue = boundValue.wrappedValue
    }
    
    /// toggle presentation of the sheet
    private func toggle() {
        presenting.toggle()
    }
    /// accept the scanned value and dismiss the sheet
    private func insert() {
        value = scannedValue
        toggle()
    }
    var body:some View {
        Button(action: toggle) {
            Image(systemName: "text.viewfinder")
        }
        .sheet(
            isPresented: $presenting
        ) {
            VStack{
                DataScannerView(scanable: $scannedValue)
                Text(scannedValue.scanFormatted()).font(.title)
                HStack{
                    Button("Insert", action: insert )
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal, 50)
                   
                    Button("Cancel", action: toggle )
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 50)
                }
            }
        }
    }
}

private struct DataScannerView<T>: UIViewControllerRepresentable where T: Scanable {
    @Binding var scanable: T
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let viewController = DataScannerViewController(
            recognizedDataTypes:  scanable.recognizedDataTypes(),
            isHighlightingEnabled: true
        )
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ viewController: DataScannerViewController, context: Context) {
        try? viewController.startScanning()
    }
    
    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: DataScannerView
        init(_ parent: DataScannerView) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd: [RecognizedItem], allItems: [RecognizedItem]){
            if let item = didAdd.first {
                switch item {
                case .text(let text):
                    parent.scanable.value(from: text.transcript)
                case .barcode(let barcode):
                    if let payload = barcode.payloadStringValue {
                        parent.scanable.value(from: payload)
                    }
                @unknown default:
                    break;
                }
            }
        }
    }
}
