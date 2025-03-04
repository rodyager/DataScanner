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
    
    init(_ boundValue: Binding<T>) { _value = boundValue }
    
    private func toggle() { presenting.toggle() }
    
    var body:some View {
        Button(action: toggle) {
            Image(systemName: "text.viewfinder")
        }
        .sheet(
            isPresented: $presenting
        ) {
            VStack{
                DataScannerView(scanable: $value)
                Text(value.scanFormatted()).font(.title)
                Button("Insert", action: toggle )
                    .buttonStyle(.borderedProminent)
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
            recognizedDataTypes: [ scanable.contentType()],
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
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                parent.scanable.value(from: text.transcript)
            default:
                break
            }
        }
    }
}
