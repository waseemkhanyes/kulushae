//
//  MotorMakeSingleView.swift
//  Kulushae
//
//  Created by Waseem  on 13/11/2024.
//

import SwiftUI
import Kingfisher

struct MotorMakeSingleView: View {
    @StateObject var dataHandler: MotorMakeSingleModel.ViewModel
    
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) var dismiss
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    @State private var fromYear: Int = 1960 // Default from year
    @State private var toYear: Int = Calendar.current.component(.year, from: Date()) // Default to current year
    @State private var showFromYearPicker = false // State to control showing From Year Picker
    @State private var showToYearPicker = false // State to control showing To Year Picker
    
    let startYear: Int = 1960
    let currentYear: Int = Calendar.current.component(.year, from: Date())
    
    
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            VStack(spacing: 0) {
                if dataHandler.arrayMotorModels.isEmpty && dataHandler.isShowEmptyMessage {
                    NoItemFoundView(isShowBackButton: false)
                } else {
                    VStack(alignment: .leading) {
                        
                        VStack(alignment: .leading) {
                            topView
                            
                            searchAndFilterView
                                .padding(.horizontal, 18)
                            
                            allButtonView
                        }
                        .padding(.bottom, 10)
                        .background(.white)
                        
                        if self.dataHandler.arrayFilteredMotorModels.isEmpty {
                            VStack(spacing: 0) {
                                NoItemFoundView(isShowBackButton: false)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 240)
                        } else {
                            carsListView
                        }
                        
                        selectYearView
//                            .padding(.top, 82)
                            .padding(.top, 30)
                        
                        Spacer()
                        
                        bottomView
                    }
                }
            }
            .cleanNavigation()
            .fullScreenCover(isPresented: $showFromYearPicker) {
                YearPickerView(title: "From Year", selectedYear: fromYear, minYear: startYear, maxYear: currentYear) { year in
                    showFromYearPicker.toggle()
                    if let year {
                        fromYear = year
                    }
                }
                .clearBackground()
            }
            .fullScreenCover(isPresented: $showToYearPicker) {
                YearPickerView(title: "To Year", selectedYear: toYear, minYear: startYear, maxYear: currentYear) { year in
                    showToYearPicker.toggle()
                    if let year {
                        toYear = year
                    }
                }
                .clearBackground()
            }
            .background(
                navigationLinks
            )
        }
    }
    
    var topView: some View {
        HStack(spacing: 0) {
            Button(action: {
                dismiss()
            }) {
                VStack(spacing: 0) {
                    Image(.back)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 15, alignment: .center)
                        .clipped()
                        .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
                        .padding(.leading, 20)
                }
            }
            
            Text(LocalizedStringKey(dataHandler.motorMake.title))
                .font(.roboto_22_semi())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
                .padding(.leading, 10)
            
            Spacer()
        }
        .frame(height: 50)
        .padding(.top, safeAreaInsets.top)
    }
    
    var filterButtonView: some View {
        Button(action: {}) {
            VStack(spacing: 0) {
                Image(.filter)
                    .resizable()
                    .frame(width: 19.13, height: 16.75)
            }
            .frame(width: 45, height: 45)
            .background {
                RoundedRectangle(cornerRadius: 22.5)
                    .stroke(Color(hex: "#F0F0F0"), lineWidth: 1)
            }
        }
    }
    
    var searchView: some View {
        VStack(spacing: 0) {
            TextField(LocalizedStringKey("Search"), text: $dataHandler.searchText)
            
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .padding(.horizontal, 18)
                .font(.roboto_16())
                .frame(height: 45)
            
        }
        .frame(height: 45)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 22.5)
                .stroke(Color(hex: "#F0F0F0"), lineWidth: 1)
        }
    }
    
    var searchAndFilterView: some View {
        HStack(spacing: 13) {
            searchView
            
            //            filterButtonView
        }
    }
    
    var allButtonView: some View {
        MultiSelectionNewButton(title: "All" , isSelected: dataHandler.isAll) {
            dataHandler.isAll.toggle()
        }
        .padding(.leading, 16)
        
//        Button(action: dataHandler.onClickAll) {
//            HStack(spacing: 0) {
//                VStack(spacing: 0) {
//                    if dataHandler.isAll {
//                        Circle()
//                            .fill(Color(hex: 0xFE820E))
//                            .frame(width: 12, height: 12)
//                    }
//                }
//                .frame(width: 20, height: 20)
//                .cornerRadius(20)
//                .background {
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(Color(hex: dataHandler.isAll ? 0xFE820E : 0xC2C2C2), lineWidth: 1.0)
//                }
//                
//                Text(LocalizedStringKey("All"))
//                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
//                    .font(.Roboto.Medium(of: 16))
//                    .foregroundStyle(.black)
//                    .padding(.leading, 10)
//            }
//            .frame(height: 50)
//        }
//        .padding(.horizontal, 16)
    }
    
    var carsListView: some View {
        ScrollView(.horizontal, showsIndicators: false) { // Scroll horizontally
            LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 21), count: 2), spacing: 14) {
                ForEach(Array(dataHandler.arrayFilteredMotorModels.enumerated()), id: \.element.id) { itemIndex, item in
                    let isSelected = item.id ?? "" == dataHandler.selectedModel?.id ?? ""
                    
                    MotorMakeSingleItemView(motorModel: item, isSelected: isSelected)
                        .onTapGesture {
                            dataHandler.onClickModel(item)
                        }
                }
            }
            .frame(height: 242)
            .padding(.horizontal, 18)
        }
    }
    
    var fromDateView: some View {
        ZStack(alignment: .topLeading) {
            Button(action: {
                showFromYearPicker = true
            }) {
                HStack(spacing: 0) {
                    Text(String(format: "%04d", fromYear))
                        .environment(\.locale, .init(identifier: "en"))
                        .font(.roboto_14())
                        .foregroundStyle(.black)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    Image(.imgCalendar)
                        .resizable()
                        .frame(width: 16.67, height: 16.67)
                        .padding(.trailing, 16)
                }
                .frame(height: 38)
                .frame(maxWidth: .infinity)
            }
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(hex: 0xD1D1D1), lineWidth: 1.0)
            }
            .padding(.top, 6)
            
            Text(LocalizedStringKey("From"))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .font(.Roboto.Light(of: 10))
                .foregroundStyle(Color(hex: 0xD1D1D1))
                .frame(height: 12)
                .background(.white)
                .padding(.leading, 11)
            
        }
    }
    
    var dashView: some View {
        HStack(spacing: 0) {
            Text("-")
                .font(.roboto_14())
                .foregroundStyle(.black)
        }
        .frame(width: 38.86, height: 38)
        .background {
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(hex: 0xD1D1D1), lineWidth: 1.0)
        }
        .padding(.top, 6)
    }
    
    var toDateView: some View {
        ZStack(alignment: .topLeading) {
            Button(action: {
                showToYearPicker = true
            }) {
                HStack(spacing: 0) {
                    Text(String(format: "%04d", toYear))
                        .environment(\.locale, .init(identifier: "en"))
                        .font(.roboto_14())
                        .foregroundStyle(.black)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    Image(.imgCalendar)
                        .resizable()
                        .frame(width: 16.67, height: 16.67)
                        .padding(.trailing, 16)
                }
                .frame(height: 38)
                .frame(maxWidth: .infinity)
            }
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(hex: 0xD1D1D1), lineWidth: 1.0)
            }
            .padding(.top, 6)
            
            Text(LocalizedStringKey("To"))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .font(.Roboto.Light(of: 10))
                .foregroundStyle(Color(hex: 0xD1D1D1))
                .frame(height: 12)
                .background(.white)
                .padding(.leading, 11)
            
        }
    }
    
    var selectYearView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStringKey("Select Year"))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .font(.roboto_14_Medium())
                .foregroundStyle(.black)
            
            HStack(spacing: 19) {
                fromDateView
                
                dashView
                
                toDateView
            }
        }
        .padding(.horizontal, 18)
    }
    
    var bottomView: some View {
        VStack(spacing: 0) {
            Button(action: {
                dataHandler.onClickApplyForAll()
            }) {
                VStack(spacing: 0) {
                    Text(LocalizedStringKey("Apply for All"))
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .font(.Roboto.Bold(of: 14))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background {
                    RoundedRectangle(cornerRadius: 27)
                        .fill(Color(hex: 0xFE820E))
                }
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 10)
            
            VStack(spacing: 0) {}
                .background(.white)
                .frame(maxWidth: .infinity)
                .frame(height: safeAreaInsets.bottom)
        }
    }
    
    private var navigationLinks: some View {
        Group {
            
//            NavigationLink("", destination: CarsSearchResultView(argsDictionary: argData(), selectedCatId: dataHandler.selectedCategory.id), isActive: $dataHandler.isCarsSearchResultOpen)
            NavigationLink("", destination: CarListScreenView(dataHandler: .init(categoryId: dataHandler.selectedCategory.id, userId: nil, argsDictionary: argData())), isActive: $dataHandler.isCarsSearchResultOpen)
        }
    }
    
    func argData() -> [String: String?] {
        let makeId = dataHandler.motorMake.id
//        let model_id = dataHandler.selectedModel?.id ?? "0"
        var params: [String: String] = [
            "make_id": makeId, "start_year": "\(fromYear)", "end_year": "\(toYear)"
        ]
        if let model = dataHandler.selectedModel {
            params["model_id"] = model.id ?? ""
        }
        return params
    }
}

fileprivate struct MotorMakeSingleItemView: View {
    var motorModel: MotorModel
    var isSelected: Bool = false
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            VStack(spacing: 0) {
                Text(LocalizedStringKey(motorModel.title ?? ""))
                    .font(.roboto_14())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 5)
            }
            .frame(width: 122, height: 26)
            .background {
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(Color(hex: isSelected ? 0xFE820E : 0xCCCCCC), lineWidth: 1.0)
            }
            
            VStack(spacing: 0) {
                KFImage(URL(string: Config.imageBaseUrl + (motorModel.image ?? "")))
                    .placeholder {
                        Image("default_property")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 62)
                            .cornerRadius(15, corners: [.topLeft, .topRight])
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(14)
                    .clipped()
//                    .background(.blue)
            }
            .frame(width: 122, height: 79)
//            .background(.brown)
            .clipped()
            .padding(1)
            .background {
                RoundedRectangle(cornerRadius: 15.0)
                    .stroke(Color(hex: isSelected ? 0xFE820E : 0xCCCCCC), lineWidth: 1.0)
            }
        }
    }
}

struct YearPickerView: View {
    var title: String
    @State var selectedYear: Int
    let minYear: Int
    let maxYear: Int
    @EnvironmentObject var languageManager: LanguageManager
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    var action: ((Int?)->())? = nil
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        action?(nil)
                    }
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(LocalizedStringKey(title))
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundStyle(.black)
                            .font(.Roboto.Bold(of: 16))
                        
                        Spacer()
                        
                        Button(LocalizedStringKey("Done")) {
                            action?(selectedYear)
                        }
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    }
                    .frame(minHeight: 50)
                    .padding(.horizontal, 18)
                    
                    Picker(LocalizedStringKey("Year"), selection: $selectedYear) {
                        ForEach(minYear...maxYear, id: \.self) { year in
                            let formattedYear = NumberFormatter.localizedString(from: NSNumber(value: year), number: .decimal)
                            Text(String(format: "%04d", year)).tag(year)
                                .environment(\.locale, .init(identifier: "en"))
                                .font(.Roboto.Regular(of: 14))
                                .foregroundStyle(.black)
                                .onAppear {
                                    print("** wk year: \(year)")
                                }
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .frame(height: 200)
                }
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .transition(.move(edge: .bottom))
                
                Spacer()
                    .frame(height: safeAreaInsets.bottom)
//                    .padding(.bottom, )
                    .frame(maxWidth: .infinity)
                    .background(.white)
            }
        }
    }
}

//#Preview {
//    MotorMakeSingleView()
//}

