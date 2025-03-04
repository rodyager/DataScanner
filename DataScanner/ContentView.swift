//
//  ContentView.swift
//  DataScanner
//
//  Created by Rod Yager on 4/3/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State var date = Date()
    @State var amount = 0.0
    var body: some View {
        VStack {
            Form{
                Section(header: Text("Data")) {
                    HStack{
                        DatePicker("Date",
                                   selection: $date,
                                   displayedComponents: [.date]
                        )
                        .environment(\.locale,
                                      Locale(identifier: "en_AU")
                        )
                        DataButton($date)
                    }
                    HStack{
                        Text("Amount:")
                        Spacer()
                        TextField("Amount",
                                  value: $amount,
                                  formatter: NumberFormatter.currency
                        )
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numbersAndPunctuation)
                        .padding(.trailing, 10)
                        DataButton($amount)
                        
                    }
        }
        
    }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
