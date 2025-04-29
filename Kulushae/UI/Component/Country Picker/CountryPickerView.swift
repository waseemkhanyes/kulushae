//
//  CountryPickerView.swift
//  Wooter
//
//  Created by Sameer on 10/10/2023.
//

import SwiftUI
import PhoneNumberKit

struct PhoneIDAndCodeData: Identifiable {
    var id: String { region }
    
    let region:String
    let flag:String
    let name:String
    let code:String
}

class CountryPickerViewViewModel: ObservableObject {
    
    @Published var arrayCountries:[PhoneIDAndCodeData] = []
    @Published var searchText:String = ""
    @Published var selectedCountry:String = ""
    
    lazy var arrayCountriesBackup:[PhoneIDAndCodeData] = phoneNumberKit.allCountries().map { country in
        let flag = country.flag
        guard let countryCode = phoneNumberKit.countryCode(for: country), flag.count == 1 else { return nil }
        
        return PhoneIDAndCodeData(region: country, flag: flag, name: country.isoToCountry, code: "+\(countryCode)")
    }.compactMap { $0 }.sorted(by: { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending })
    
    let phoneNumberKit = PhoneNumberKit()
    var completionHandler:((PhoneIDAndCodeData?)->())? = nil
    
    init(selectedCountry:String, _ completionHandler:((PhoneIDAndCodeData?)->())? = nil) {
        self.selectedCountry = selectedCountry
        self.completionHandler = completionHandler
        arrayCountries = arrayCountriesBackup
    }
    
    func search() {
        guard !searchText.isEmpty else {
            onClickSearchCross()
            return
        }
        
        arrayCountries = arrayCountriesBackup.filter { $0.name.lowercased().contains(searchText.lowercased())}
    }
    
    func onClickSearchCross() {
        searchText = ""
        arrayCountries = arrayCountriesBackup
    }
    
    func onClickBack(_ dismiss:DismissAction) {
        dismiss()
        self.completionHandler?(nil)
    }
    
    func onClickCountry(_ country:PhoneIDAndCodeData, _ dismiss:DismissAction) {
        dismiss()
        self.completionHandler?(country)
    }
}

extension VerticalAlignment {
    /// A custom alignment for image titles.
    private struct IconAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            // Default to bottom alignment if no guides are set.
            context[VerticalAlignment.center]
        }
    }


    /// A guide for aligning titles.
    static let IconAlignmentGuide = VerticalAlignment(
        IconAlignment.self
    )
}

struct CountryPickerView: View {
    
    @StateObject var viewModel:CountryPickerViewViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState var isFocused:Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            topHeader
            
            countriesList
        }
    }
    
    var topHeader:some View {
        HStack(alignment: .IconAlignmentGuide, spacing: 0) {
            
            backButton
            
            searchTextField
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
    }
    
    var backButton: some View {
        Button(action: { viewModel.onClickBack(dismiss) }) {
            Image(.back)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.black.opacity(0.54))
                .frame(height: 16)
                .alignmentGuide(.IconAlignmentGuide) { context in
                    context[VerticalAlignment.center]
                }
        }
        .frame(width: 56)
        .frame(maxHeight: .infinity)
    }
    
    var searchTextField: some View {
        HStack(spacing: 0) {
            TextField("Search...", text: $viewModel.searchText.onChange { _ in  viewModel.search() })
                .font(.Roboto.Light(of: 14))
                .padding(.horizontal, 11)
                .keyboardType(.default)
                .focused($isFocused)
            
            Button(action: viewModel.onClickSearchCross) {
                Image(.back)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(.black.opacity(0.54))
                    .frame(height: 14)
                    .alignmentGuide(.IconAlignmentGuide) { context in
                        context[VerticalAlignment.center]
                    }
            }
            .frame(width: 48)
            .frame(maxHeight: .infinity)
            .opacity(viewModel.searchText.isEmpty ? 0 : 1)
            .disabled(viewModel.searchText.isEmpty)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color.unselectedBorderColor, lineWidth: 1)
        )
        .onTapGesture {
            isFocused = true
        }
        .padding(.top, 12)
        .padding(.trailing, 16)
    }
    
    var countriesList: some View {
        List {
            ForEach(viewModel.arrayCountries) { country in
                CountryPickerItemView(
                    viewModel: .init(
                        country: country,
                        isSelected: viewModel.selectedCountry == country.id
                    )
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.onClickCountry(country, dismiss)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 5)
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}


#Preview {
    CountryPickerView(viewModel: .init(selectedCountry: "US"))
}


extension String {
    var isoToCountry:String {
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: self])
        let name = NSLocale(localeIdentifier: NSLocale.current.identifier)
            .displayName(forKey: NSLocale.Key.identifier, value: id) ?? self
        return name
    }
    
    var flag:String {
        let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
        return self
            .uppercased()
            .unicodeScalars
            .compactMap { UnicodeScalar(flagBase + $0.value)?.description }
            .joined()
    }
}
