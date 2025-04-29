//
//  CountryPickerItemView.swift
//  Wooter
//
//  Created by Sameer on 11/10/2023.
//

import SwiftUI

class CountryPickerItemViewModel {
    let country:PhoneIDAndCodeData
    let isSelected:Bool
    
    init(country: PhoneIDAndCodeData, isSelected: Bool) {
        self.country = country
        self.isSelected = isSelected
    }
}

struct CountryPickerItemView: View {
    
    var viewModel:CountryPickerItemViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("\(viewModel.country.flag)  \(viewModel.country.name)")
                    .foregroundStyle(.black.opacity(0.87))
                Spacer()
                Text(viewModel.country.code)
                    .foregroundStyle(viewModel.isSelected ? .white : .black.opacity(54))
                    .padding(.all, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(viewModel.isSelected ? Color.black.opacity(0.54) : .clear)
                    )
            }
            .font(.Roboto.Light(of: 14))
            
            Color.black.opacity(0.25)
                .frame(height: 0.5)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
        }
        .listRowSeparator(.hidden)
        .listRowInsets(.zero)
    }
}

#Preview {
    VStack {
        let countryData = PhoneIDAndCodeData(region: "US", flag: "🇺🇸", name: "United States", code: "+1")
        CountryPickerItemView(viewModel: .init(country: countryData, isSelected: true))
        
        CountryPickerItemView(viewModel: .init(country: countryData, isSelected: false))
    }
}
