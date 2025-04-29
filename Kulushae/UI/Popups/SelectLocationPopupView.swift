//
//  SelectLocationPopupView.swift
//  Kulushae
//
//  Created by Waseem  on 03/12/2024.
//

import SwiftUI

struct SelectLocationPopupView: View { 
    
    @StateObject var viewModel: SelectLocationPopupViewModel.ViewModel
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear
            
            VStack(spacing: 0) {
                
                headerView
                
                arrayStateView
                
                okButtonView
            }
            .frame(maxWidth: .infinity)
            .background(
                Color.white
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .padding(.top, 28)
        .overlay {
            if(viewModel.errorString != "") {
                TopStatusToastView(message: viewModel.errorString, type: .error) {
                    viewModel.errorString = ""
                }
            }
        }
        .environment(\.layoutDirection, languageManager.layoutDirection)
        .cleanNavigation()
        .fullScreenCover(isPresented: $viewModel.isPresentLocation) {
            ChooseCountryPopUpView(viewModel: .init(selectedCountryWithState: viewModel.selectedCountry, handler: viewModel.onClickDismissDesireLocation))
                .clearBackground()
        }
    }
    
    var headerView: some View {
        VStack(spacing: 0) {
            headerTitleView
            
            selectCountryView
        }
        .readSize { size in
            viewModel.topHeader = size.height
        }
    }
    
    var headerTitleView: some View {
        Text(LocalizedStringKey("Choose the Desire Location"))
            .textStyle(font: Font.Roboto.Regular(of: 20), color: Color(hex: 0x000000))
            .fontWeight(.bold)
            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
            .padding(.top, 36)
    }
    
    var selectCountryView: some View {
        Button(action: {
            viewModel.isPresentLocation = true
        }) {
            HStack(spacing: 21) {
                if let name = viewModel.countryName {
                    Text(name)
                        .textStyle(font: Font.Roboto.Regular(of: 14), color: Color(hex: 0x000000))
                        .fontWeight(.bold)
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                } else {
                    Text(LocalizedStringKey("Select Country"))
                        .textStyle(font: Font.Roboto.Regular(of: 14), color: Color(hex: 0x000000))
                        .fontWeight(.bold)
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                }
                
                Image("arrow_top_down")
                    .resizable()
                    .frame(width: 15.6, height: 14)
            }
            .padding(EdgeInsets(top: 14, leading: 15, bottom: 14, trailing: 10))
            .background(
                Color.white
                    .border(Color(hex: 0x000000, alpha: 0.2), width: 1, cornerRadius: 10)
            )
        }
        .padding(.top, 16)
    }
    
    var arrayStateView: some View {
        ScrollView {
            FlexibleView(availableWidth: UIScreen.main.bounds.width - 40, arrayData: viewModel.getCountryStates(), VSpacing: 13, spacing: 10, alignment: .center) { item in
                
                Button(action: {
                    viewModel.onClickSelectState(stateID: item.id)
                }) {
                    stateItemView(item: item)
                }
            }
            .padding(.top, 35)
            .readSize { size in
                viewModel.scrollContent = size.height
            }
        }
        .frame(height: viewModel.scrollHeight())
    }
    
    func stateItemView(item: FlexibleViewModel) -> some View {
        let isSelected = viewModel.selectedCountry?.selectedStateID ?? 0 == item.id //|| viewModel.selectedStateID == 0
        return Text(item.name)
            .textStyle(font: .Roboto.Regular(of: 14), color: Color(hex: isSelected ? 0xFFFFFF : 0x000000))
            .fontWeight(.regular)
            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background(
                Color(hex: isSelected ? 0x79A7C9 : 0xFFFFFF)
                    .cornerRadius(10)
                    .border(Color(hex: isSelected ? 0x79A7C9 : 0x000000), width: 1, cornerRadius: 10)
            )
    }
    
    var okButtonView: some View {
        Button(action: {
            viewModel.onClickOk()
        }) {
            Text(LocalizedStringKey("Ok"))
                .textStyle(font: .Roboto.Regular(of: 16), color: Color(hex: 0x000000))
                .fontWeight(.bold)
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .frame(width: 150, height: 48)
                .background(
                    Color.white
                        .border(Color(hex: 0x000000), width: 1, cornerRadius: 20)
                )
        }
        .padding(.top, 35)
        .padding(.bottom, 24)
        .readSize { size in
            viewModel.footer = size.height
        }
    }
}

#Preview {
    SelectLocationPopupView(viewModel: .init(type: .ForSearch))
}
