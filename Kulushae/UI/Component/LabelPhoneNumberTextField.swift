//
//  LabelPhoneNumberTextField.swift
//  Kulushae
//
//  Created by Waseem  on 25/12/2024.
//

import SwiftUI
import PhoneNumberKit

struct LabelPhoneNumberTextField: View {
    let placeholder: String
    
    @Binding var selectedCountry: String
    @Binding var text: String
    
    @State var shouldShowPicker = false
    
    @State var isEnableExtraTitle = false
    @State var extraImage: String = "question"
    @State private var isPopoverVisible = false
    
    let phoneNumberKit = PhoneNumberKit()
    let partialFormatter = PartialFormatter()
    
    @FocusState private var isFocused: Bool
    private var borderColor: Color {
        isFocused ? .black : .unselectedBorderColor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
//        ZStack {
//            if(text != "") {
//                HStack {
//                    if(isEnableExtraTitle) {
//                        Spacer()
//                    }
//                    VStack {
//                        HStack {
//                            Text(LocalizedStringKey(placeholder))
//                                .font(.roboto_16())
//                                .fontWeight(.bold)
//                                .foregroundColor(Color.black)
//                            
//                            if(isEnableExtraTitle) {
//                                Image(extraImage)
//                            }
//                        }
//                    }
//                    
//                    if(!isEnableExtraTitle) {
//                        Spacer()
//                    }
//                    
//                }
//                .padding(.top, 12)
//            }
            
            phoneFlagAndFieldView
        }
        .onChange(of: text) { _ in
            partialFormatter.defaultRegion = selectedCountry
            
            text.handleChangeCharacters(withKit: phoneNumberKit, andFormatter: partialFormatter)
            selectedCountry = partialFormatter.currentRegion
        }
        .sheet(isPresented: $shouldShowPicker, content: {
            CountryPickerView(viewModel: .init(selectedCountry: selectedCountry) { newCountry in
                guard let newCountry = newCountry else { return }
                
                partialFormatter.defaultRegion = selectedCountry
                
                selectedCountry = text.updateCountryAndReturn(
                    to: newCountry,
                    usingKit: phoneNumberKit,
                    andFormatter: partialFormatter
                )
            })
        })
    }
    
    var phoneFlagAndFieldView: some View {
        HStack(spacing: 0) {
            Button(action: {
                shouldShowPicker = true
            }, label: {
                Text(selectedCountry.flag)
            })
            .padding(.trailing, 12)
            .padding(.leading, 8)
            
            textFieldView
        }
        .frame(height: 60)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor, lineWidth: 1.0)
                .padding(.horizontal, 1)
        }
    }
    
    var textFieldView: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField(placeholder, text: $text)
                .font(.Roboto.Regular(of: 14))
                .frame(height: 40)
                .padding(.trailing, 15)
                .focused($isFocused)
        }
        .frame(maxWidth: .infinity)
    }
}

fileprivate extension String {
    func nonNumericSet() -> CharacterSet {
        var mutableSet = CharacterSet.decimalDigits.inverted
        mutableSet.remove(charactersIn: PhoneNumberConstants.plusChars)
        mutableSet.remove(charactersIn: PhoneNumberConstants.pausesAndWaitsChars)
        mutableSet.remove(charactersIn: PhoneNumberConstants.operatorChars)
        return mutableSet
    }
    
    func initalizeConfigAndReturn(numberkit phoneNumberKit: PhoneNumberKit, andFormatter partialFormatter:PartialFormatter) -> String {
        let number = trim(self)
        if let region = try? phoneNumberKit.parse(number).regionID {
            partialFormatter.defaultRegion = region
        }
        
        _ = partialFormatter.formatPartial(number)
        return partialFormatter.currentRegion
    }
    
    mutating func updateCountry(to newCountry: PhoneIDAndCodeData, usingKit phoneNumberKit: PhoneNumberKit, andFormatter partialFormatter:PartialFormatter) {
        var number = trim(self)
        if let oldCode = phoneNumberKit.countryCode(for: partialFormatter.currentRegion) {
            number = number.replacingOccurrences(of: "+\(oldCode)", with: "")
        }
        
        partialFormatter.defaultRegion = newCountry.region
        if number == "+" {
            number = ""
        }
        number = newCountry.code + number
        self = partialFormatter.formatPartial(number)
    }
    
    mutating func updateCountryAndReturn(to newCountry: PhoneIDAndCodeData, usingKit phoneNumberKit: PhoneNumberKit, andFormatter partialFormatter:PartialFormatter) -> String {
        updateCountry(to: newCountry, usingKit: phoneNumberKit, andFormatter: partialFormatter)
        return newCountry.region
    }
    
    mutating func handleChangeCharacters(withKit phoneNumberKit: PhoneNumberKit, andFormatter partialFormatter: PartialFormatter) {
        guard !self.isEmpty else { return }

        let oldText = self
        let filteredCharacters = self.filter {
            String($0).rangeOfCharacter(from: self.nonNumericSet()) == nil
        }
        var rawNumberString = String(filteredCharacters)

        if !rawNumberString.hasPrefix("+") {
            if let countryCode = phoneNumberKit.countryCode(for: partialFormatter.currentRegion) {
                rawNumberString = "+\(countryCode)" + rawNumberString
            } else {
                rawNumberString = "+1" + rawNumberString
            }
        }

        let formattedNationalNumber = partialFormatter.formatPartial(rawNumberString)
        
        self = formattedNationalNumber

        if let region = try? phoneNumberKit.parse(oldText, withRegion: partialFormatter.currentRegion).regionID {
            partialFormatter.defaultRegion = region
        }
    }
}

struct PhoneNumberConstants {
    static let plusChars = "+＋"
    static let pausesAndWaitsChars = ",;"
    static let operatorChars = "*#"
}

#Preview {
    LabelPhoneNumberTextField(placeholder: "Phone Number", selectedCountry: .constant(""), text: .constant(""))
}
