//
//  test.swift
//  Kulushae
//
//  Created by ios on 21/02/2024.
//

import SwiftUI

struct test: View {
    let numberFormatter = NumberFormatter()
   
    
    var body: some View {
        @State var lowValueText = ""
        TextField("", value: $lowValueText, formatter: numberFormatter, onEditingChanged: { editing in
                     if editing {
                         // Handle text field editing when lowValueText changes
//                                                 let newValue = Double(lowValueText) ?? 0.0
//                                                 priceSlider.lowHandle.currentPercentage.wrappedValue = min(max(0.0, newValue / (priceSlider.valueEnd - priceSlider.valueStart)), 1.0)
                         print("dvf")
                     }
                 })
        .onAppear(){
            numberFormatter.numberStyle = .decimal
        }
    }
       
}

#Preview {
    test()
}
