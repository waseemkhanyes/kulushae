//
//  YearItemForMotorFilterView.swift
//  Kulushae
//
//  Created by Waseem  on 01/01/2025.
//

import SwiftUI

struct FilterRangeItemView: View {
    @StateObject var priceSlider: CustomSlider
    @Binding var data: JSON
    
//    @StateObject var priceSlider = CustomSlider(start: data, end: 2026)
    @State var lowValueText = ""
    @State var upperValueText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            titleView
            
            fromAndToView
            
            sliderView
        }
        .frame(maxWidth: .infinity)
    }
    
    var titleView: some View {
        Text(data["title"].stringValue)
            .font(.Roboto.Bold(of: 18))
            .foregroundStyle(.black)
            .padding(.bottom, 10)
    }
    
    var fromAndToView: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                TextField(data["extras"]["min"].stringValue, text: $lowValueText.onChange { newValue in
                    updateDataValue(key: "min", value: newValue)
                })
                    .font(.Roboto.Regular(of: 16))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 10)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 1)
            }
            
            Text("to")
                .font(.Roboto.Regular(of: 14))
                .foregroundStyle(.black)
                .padding(.horizontal, 10)
            
            VStack(spacing: 0) {
                TextField(data["extras"]["max"].stringValue, text: $upperValueText.onChange { newValue in
                    updateDataValue(key: "max", value: newValue)
                })
                    .font(.Roboto.Regular(of: 16))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 10)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 1)
            }
        }
    }
    
    var sliderView: some View {
        SliderView(slider: priceSlider)
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .onReceive(priceSlider.lowHandle.$onDrag) { onDrag in
                if onDrag {
                    lowValueText = String(format: "%.0f", priceSlider.lowHandle.currentValue)
                } else {
                    updateDataValue(key: "min", value: lowValueText)
                }
            }
            .onReceive(priceSlider.highHandle.$onDrag) { onDrag in
                if onDrag {
                    upperValueText = String(format: "%.0f", priceSlider.highHandle.currentValue)
                } else {
                    updateDataValue(key: "max", value: upperValueText)
                }
            }
    }
    
    func updateDataValue(key: String, value: String) {
        var selection = data["selection"]
        if selection.isEmpty {
            selection = JSON([:])
        }
        selection[key].stringValue = value
        data["selection"] = selection
    }
}

#Preview {
    FilterRangeItemView(priceSlider: .init(start: 0, end: 10), data: .constant(JSON([:])))
}

//HStack {
//    Text(LocalizedStringKey("Price Range"))
//        .font(.roboto_16_bold())
//        .fontWeight(.bold)
//        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
//        .foregroundColor(Color.black)
//    Spacer()
//}
//.frame(height: 18)
//.padding(.vertical)
//Group {
//    HStack{
//        ZStack(alignment: .trailing) {
//               TextField("0", text: $lowValueText)
//                .font(.roboto_14())
//                   .onChange(of: lowValueText) { newValue in
//                       if let newValue = Double(newValue) {
//                           let normalizedValue = min(max(0.0, newValue / (priceSlider.valueEnd - priceSlider.valueStart)), 1.0)
//                           
//                           // Update slider handles directly, ensuring consistency:
//                           priceSlider.lowHandle.currentPercentage.wrappedValue = normalizedValue
//                           if normalizedValue > priceSlider.highHandle.currentPercentage.wrappedValue {
//                               priceSlider.highHandle.currentPercentage.wrappedValue = normalizedValue
//                           }
//                           priceSlider.updateHandleLocations()
//                           // Trigger notification for visual updates:
//                           priceSlider.objectWillChange.send()
//                       }
//                   }
//                   .textFieldStyle(PlainTextFieldStyle()) // Use PlainTextFieldStyle to remove border
//                   .padding()
//                   .keyboardType(.decimalPad)
//               
//               Text(LocalizedStringKey("AED"))
//                   .font(.roboto_14())
//                   .environment(\.locale, .init(identifier: languageManager.currentLanguage))
//                   .padding(.trailing)
//                   .multilineTextAlignment(.leading)
//           }
//           .frame(height: 50)
//           .overlay(RoundedRectangle(cornerRadius: 10)
//               .inset(by: 0.5)
//               .stroke(Color.unselectedBorderColor, lineWidth: 1))
//        HStack {
//            Text("-")
//                .font(.roboto_14())
//                .padding()
//                .frame(width: 35)
//        }
//        .overlay(RoundedRectangle(cornerRadius: 10)
//            .inset(by: 0.5)
//            .stroke(Color.unselectedBorderColor, lineWidth: 1))
//        ZStack(alignment: .trailing) {
//               TextField("0", text: $upperValueText)
//                .font(.roboto_14())
//                   .onChange(of: upperValueText) { newValue in
//                       if let newValue = Double(newValue) {
//                           let normalizedValue = min(max(0.0, newValue / (priceSlider.valueEnd - priceSlider.valueStart)), 1.0)
//                           
//                           priceSlider.highHandle.currentPercentage.wrappedValue = normalizedValue
//                           if normalizedValue < priceSlider.lowHandle.currentPercentage.wrappedValue {
//                               priceSlider.lowHandle.currentPercentage.wrappedValue = normalizedValue
//                           }
//                           
//                           priceSlider.updateHandleLocations()
//                           priceSlider.objectWillChange.send()
//                       }
//                   }
//                   .textFieldStyle(PlainTextFieldStyle()) // Use PlainTextFieldStyle to remove border
//                   .padding()
//                   .keyboardType(.decimalPad)
//               
//               Text(LocalizedStringKey("AED"))
//                   .font(.roboto_14())
//                   .environment(\.locale, .init(identifier: languageManager.currentLanguage))
//                   .padding(.trailing)
//                   .multilineTextAlignment(.leading)
//           }
//           .frame(height: 50)
//           .overlay(RoundedRectangle(cornerRadius: 10)
//               .inset(by: 0.5)
//               .stroke(Color.unselectedBorderColor, lineWidth: 1))
//        Spacer()
//    }
//}
////Slider
//SliderView(slider: priceSlider)
//    .padding(.vertical)
//    .onReceive(priceSlider.lowHandle.$onDrag) { onDrag in
//        if onDrag {
//            lowValueText = String(format: "%.2f", priceSlider.lowHandle.currentValue)
//        }
//    }
//    .onReceive(priceSlider.highHandle.$onDrag) { onDrag in
//        if onDrag {
//            upperValueText = String(format: "%.2f", priceSlider.highHandle.currentValue)
//        }
//    }
