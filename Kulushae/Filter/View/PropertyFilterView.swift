//
//  PropertyFilterView.swift
//  Kulushae
//
//  Created by ios on 09/02/2024.
//

import SwiftUI
import MapboxSearch
import Combine

struct PropertyFilterView: View {
    @Binding var argsDictionary: [String: String?]
    @Binding var isOpen: Bool
    @EnvironmentObject var languageManager: LanguageManager
    @State var isRentEnabled: Bool = true
    @State var isBuyEnabled: Bool = false
    @State var catId : Int
    @StateObject var dataHandler = HomeViewModel.ViewModel()
//    @StateObject var amenityDataHandler = AdDetailsViewModel.ViewModel()
    @StateObject var amenityDataHandler = CreateAdsFormViewModel.ViewModel(title: "", newCatIdVal: 0, stepNum: 0, serviceType: .Property)
    @State var selectedParentCatId: String = ""
    @State var selectedSubCatId: String = ""
    @ObservedObject var areaSlider = CustomSlider(start: 0, end: 99999999)
    @State var isStudioSelected = false
    @State var selectedBedroom: Int = 0
    @State var selectedBathroom: Int = 0
    @State var selectedFurnished: FurnishedModel = .all
    @State  var selectedAmenity:[String]  = []
    @State  var selectedLocationArray:[String]  = []
    @State var excludedLocationArray: [String] = []
    @State  var selectedListedBy:[String]  = []
    @State  var selectedMoreFilters:[String]  = []
    @State  var selectedAmenityIDs:[String]  = []
    @State  var selectedAmenityIDVal: String   = ""
    @State private var isSearchSheetOpen: Bool = false
    let listedByArray = ["Agent", "Developer"]
    let moreFilterArray = ["Ads with Video", "Ads with 360 Tour"]
    @StateObject var priceSlider = CustomSlider(start: 0, end: 9999999)
    @State var lowValueText = "0"
    @State var upperValueText = "99999999"
    @State var lowSizeText = "0"
    @State var upperSizeText = "9999999"
    let numberFormatter = NumberFormatter()
    @State var searchKey: String = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text(LocalizedStringKey("Advance Filter"))
                        .font(.roboto_20())
                        .fontWeight(.bold)
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .foregroundColor(Color.black)
                        .padding(.all)
                    Spacer()
                    Text(LocalizedStringKey("Close"))
                        .font(.roboto_14())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .onTapGesture() {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            argsDictionary = [:]
                            isOpen.toggle()
                        }
                        .padding(.trailing, 15)
                }
                .padding(.top)
                
                //                HStack {
                //                    Button(action: {
                //                        isBuyEnabled = false
                //                        isRentEnabled = true
                //                    }) {
                //                        Text(LocalizedStringKey("Rent"))
                //                            .font(.roboto_14())
                //                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                //                            .foregroundColor(isRentEnabled ? Color.appBackgroundColor : Color.appPrimaryColor)
                //                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 35, maxHeight: 35)
                //                            .background(isRentEnabled ? Color.appPrimaryColor : .clear)
                //                            .cornerRadius(15)
                //                            .clipped()
                //                    }
                //
                //                    Button(action: {
                //                        isRentEnabled = false
                //                        isBuyEnabled = true
                //                    }) {
                //                        Text(LocalizedStringKey("Buy"))
                //                            .font(.roboto_14())
                //                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                //                            .foregroundColor(isBuyEnabled ? Color.appBackgroundColor : Color.appPrimaryColor)
                //                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 35, maxHeight: 35)
                //                            .background(isBuyEnabled ? Color.appPrimaryColor : .clear)
                //                            .cornerRadius(15)
                //                            .clipped()
                //                    }
                //
                //                }
                //                .frame(maxWidth: .infinity)
                //                .overlay(RoundedRectangle(cornerRadius: 15)
                //                    .inset(by: 0.5)
                //                    .stroke(Color.appPrimaryColor, lineWidth: 1))
                ScrollView {
                    HStack {
                        Text(LocalizedStringKey("Property Type"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.top)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(dataHandler.categoryObjectList, id: \.self) { item in
                                SingleSelectionView(item: item, selectedItemId: $selectedParentCatId)
                            }
                        }
                    }
                    .padding(.vertical)
                    ForEach(dataHandler.subCategoryObject.chunked(into: 2), id: \.self) { subCatList in
                        HStack(spacing: 10) {
                            ForEach(subCatList, id: \.self) { subCat in
                                HStack {
                                    RadioButtonCategoryView(item: subCat, selectedId: $selectedSubCatId)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    
                    HStack {
                        Text(LocalizedStringKey("Price Range"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .frame(height: 18)
                    .padding(.vertical)
                    Group {
                        HStack{
                            ZStack(alignment: .trailing) {
                                   TextField("0", text: $lowValueText)
                                    .font(.roboto_14())
                                       .onChange(of: lowValueText) { newValue in
                                           if let newValue = Double(newValue) {
                                               let normalizedValue = min(max(0.0, newValue / (priceSlider.valueEnd - priceSlider.valueStart)), 1.0)
                                               
                                               // Update slider handles directly, ensuring consistency:
                                               priceSlider.lowHandle.currentPercentage.wrappedValue = normalizedValue
                                               if normalizedValue > priceSlider.highHandle.currentPercentage.wrappedValue {
                                                   priceSlider.highHandle.currentPercentage.wrappedValue = normalizedValue
                                               }
                                               priceSlider.updateHandleLocations()
                                               // Trigger notification for visual updates:
                                               priceSlider.objectWillChange.send()
                                           }
                                       }
                                       .textFieldStyle(PlainTextFieldStyle()) // Use PlainTextFieldStyle to remove border
                                       .padding()
                                       .keyboardType(.decimalPad)
                                   
                                   Text(LocalizedStringKey("AED"))
                                       .font(.roboto_14())
                                       .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                       .padding(.trailing)
                                       .multilineTextAlignment(.leading)
                               }
                               .frame(height: 50)
                               .overlay(RoundedRectangle(cornerRadius: 10)
                                   .inset(by: 0.5)
                                   .stroke(Color.unselectedBorderColor, lineWidth: 1))
                            HStack {
                                Text("-")
                                    .font(.roboto_14())
                                    .padding()
                                    .frame(width: 35)
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.5)
                                .stroke(Color.unselectedBorderColor, lineWidth: 1))
                            ZStack(alignment: .trailing) {
                                   TextField("0", text: $upperValueText)
                                    .font(.roboto_14())
                                       .onChange(of: upperValueText) { newValue in
                                           if let newValue = Double(newValue) {
                                               let normalizedValue = min(max(0.0, newValue / (priceSlider.valueEnd - priceSlider.valueStart)), 1.0)
                                               
                                               priceSlider.highHandle.currentPercentage.wrappedValue = normalizedValue
                                               if normalizedValue < priceSlider.lowHandle.currentPercentage.wrappedValue {
                                                   priceSlider.lowHandle.currentPercentage.wrappedValue = normalizedValue
                                               }
                                               
                                               priceSlider.updateHandleLocations()
                                               priceSlider.objectWillChange.send()
                                           }
                                       }
                                       .textFieldStyle(PlainTextFieldStyle()) // Use PlainTextFieldStyle to remove border
                                       .padding()
                                       .keyboardType(.decimalPad)
                                   
                                   Text(LocalizedStringKey("AED"))
                                       .font(.roboto_14())
                                       .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                       .padding(.trailing)
                                       .multilineTextAlignment(.leading)
                               }
                               .frame(height: 50)
                               .overlay(RoundedRectangle(cornerRadius: 10)
                                   .inset(by: 0.5)
                                   .stroke(Color.unselectedBorderColor, lineWidth: 1))
                            Spacer()
                        }
                    }
                    //Slider
                    SliderView(slider: priceSlider)
                        .padding(.vertical)
                        .onReceive(priceSlider.lowHandle.$onDrag) { onDrag in
                            if onDrag {
                                lowValueText = String(format: "%.2f", priceSlider.lowHandle.currentValue)
                            }
                        }
                        .onReceive(priceSlider.highHandle.$onDrag) { onDrag in
                            if onDrag {
                                upperValueText = String(format: "%.2f", priceSlider.highHandle.currentValue)
                            }
                        }
                    HStack {
                        Text(LocalizedStringKey("Bedroom"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    Group {
                        HStack{
                            HStack {
                                Text("Studio")
                                    .font(.roboto_14())
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                    .multilineTextAlignment(.trailing)
                                    .padding()
                            }
                            .onTapGesture() {
                                isStudioSelected.toggle()
                                selectedBedroom = 0
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.5)
                                .stroke(isStudioSelected ? Color.black : Color.customColor(hex: 0xD1D1D1), lineWidth: 1))
                            HStack {
                                Text(String(selectedBedroom))
                                    .font(.roboto_14())
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .frame(width: 100)
                            }
                            .padding(.horizontal, 15)
                            .background(Color.iconSelectionColor)
                            .cornerRadius(10)
                            .clipped()
                           
                            HStack {
                                Text("-")
                                    .foregroundColor(.black)
                                    .font(.roboto_14())
                                    .padding()
                                    .frame(width: 50)
                            }
                            .onTapGesture(){
                                if(selectedBedroom > 0) {
                                    DispatchQueue.main.async{
                                        selectedBedroom = selectedBedroom - 1
                                        isStudioSelected = false
                                    }
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.5)
                                .stroke(Color.unselectedBorderColor, lineWidth: 1))
                            
                            HStack {
                                Text("+")
                                    .font(.roboto_14())
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(width: 50)
                            }
                            .onTapGesture(){
                                DispatchQueue.main.async {
                                    selectedBedroom = selectedBedroom + 1
                                    isStudioSelected = false
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.5)
                                .stroke(Color.unselectedBorderColor, lineWidth: 1))
                            
                            Spacer()
                        }
                    }
                    
                    HStack {
                        Text(LocalizedStringKey("Bathroom"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    Group {
                        HStack{
                            HStack {
                                Text(String(selectedBathroom))
                                    .font(.roboto_14())
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 100)
                                
                            }
                            .padding(.horizontal, 15)
                            .background(Color.iconSelectionColor)
                            .cornerRadius(10)
                            .clipped()
                            HStack {
                                Text("-")
                                    .font(.roboto_14())
                                    .padding()
                                    .frame(width: 50)
                            }
                            .onTapGesture() {
                                DispatchQueue.main.async{
                                    if(selectedBathroom > 0) {
                                        selectedBathroom = selectedBathroom - 1
                                    }
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.5)
                                .stroke(Color.unselectedBorderColor, lineWidth: 1))
                            
                            HStack {
                                Text("+")
                                    .font(.roboto_14())
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(width: 50)
                            }
                            .onTapGesture(){
                                DispatchQueue.main.async {
                                    selectedBathroom = selectedBathroom + 1
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.5)
                                .stroke(Color.unselectedBorderColor, lineWidth: 1))
                            
                            Spacer()
                        }
                    }
                    //MARK: Area / Size
                    HStack {
                        Text(LocalizedStringKey("Area / Size"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .frame(height: 18)
                    .padding(.vertical)
                    Group {
                        HStack{
                            ZStack(alignment: .trailing) {
                                   TextField("0", text: $lowSizeText)
                                    .font(.roboto_14())
                                       .onChange(of: lowSizeText) { newValue in
                                           if let newValue = Double(newValue) {
                                               let normalizedValue = min(max(0.0, newValue / (areaSlider.valueEnd - areaSlider.valueStart)), 1.0)
                                               areaSlider.lowHandle.currentPercentage.wrappedValue = normalizedValue
                                               if normalizedValue > areaSlider.highHandle.currentPercentage.wrappedValue {
                                                   areaSlider.highHandle.currentPercentage.wrappedValue = normalizedValue
                                               }
                                               areaSlider.updateHandleLocations()
                                               areaSlider.objectWillChange.send()
                                           }
                                       }
                                       .textFieldStyle(PlainTextFieldStyle()) // Use PlainTextFieldStyle to remove border
                                       .padding()
                                       .keyboardType(.decimalPad)
                                   
                                   Text(LocalizedStringKey("Sqft"))
                                       .font(.roboto_14())
                                       .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                       .padding(.trailing)
                                       .multilineTextAlignment(.leading)
                               }
                               .frame(height: 50)
                               .overlay(RoundedRectangle(cornerRadius: 10)
                                   .inset(by: 0.5)
                                   .stroke(Color.unselectedBorderColor, lineWidth: 1))
                            HStack {
                                Text("-")
                                    .font(.roboto_14())
                                    .padding()
                                    .frame(width: 35)
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.5)
                                .stroke(Color.unselectedBorderColor, lineWidth: 1))
                            ZStack(alignment: .trailing) {
                                   TextField("0", text: $upperSizeText)
                                    .font(.roboto_14())
                                       .onChange(of: upperSizeText) { newValue in
                                           if let newValue = Double(newValue) {
                                               let normalizedValue = min(max(0.0, newValue / (areaSlider.valueEnd - areaSlider.valueStart)), 1.0)
                                               
                                               areaSlider.highHandle.currentPercentage.wrappedValue = normalizedValue
                                               if normalizedValue < areaSlider.lowHandle.currentPercentage.wrappedValue {
                                                   areaSlider.lowHandle.currentPercentage.wrappedValue = normalizedValue
                                               }
                                               
                                               areaSlider.updateHandleLocations()
                                               areaSlider.objectWillChange.send()
                                           }
                                       }
                                       .textFieldStyle(PlainTextFieldStyle()) // Use PlainTextFieldStyle to remove border
                                       .padding()
                                       .keyboardType(.decimalPad)
                                   Text(LocalizedStringKey("AED"))
                                       .font(.roboto_14())
                                       .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                       .padding(.trailing)
                                       .multilineTextAlignment(.leading)
                               }
                               .frame(height: 50)
                               .overlay(RoundedRectangle(cornerRadius: 10)
                                   .inset(by: 0.5)
                                   .stroke(Color.unselectedBorderColor, lineWidth: 1))
                        }
                    }
                    //Slider
                    SliderView(slider: areaSlider)
                        .padding(.vertical)
                        .onReceive(areaSlider.lowHandle.$onDrag) { onDrag in
                            if onDrag {
                                lowSizeText = String(format: "%.2f", areaSlider.lowHandle.currentValue)
                            }
                        }
                        .onReceive(areaSlider.highHandle.$onDrag) { onDrag in
                            if onDrag {
                                upperSizeText = String(format: "%.2f", areaSlider.highHandle.currentValue)
                            }
                        }
                    //MARK: Furnishing Type
                    HStack {
                        Text(LocalizedStringKey("Furnishing Type"))
                            .font(.roboto_16_bold())
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    FurnishedView(selectedFurnished: $selectedFurnished)
                    //MARK: Amenities
                    HStack {
                        Text(LocalizedStringKey("Amenities"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                        Text(LocalizedStringKey("See All"))
                            .font(.roboto_14())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                            .onTapGesture(){
                                amenityDataHandler.isAmenityChosen = true
                            }
                        
                            .padding()
                    }
                    .padding(.vertical)
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(amenityDataHandler.amenityData, id: \.self) { item in
                                MultiSelectionButton(titleVal: item.title , isSelected: .constant(selectedAmenity.contains(item.title)), selectedArray: $selectedAmenity)
                                    .onTapGesture {
                                        if(!selectedAmenity.contains(item.title)) {
                                            selectedAmenityIDVal = selectedAmenityIDs.joined(separator: ",")
                                            selectedAmenityIDs.append(item.id)
                                            selectedAmenity.append(item.title)
                                        } else {
                                            if let index = selectedAmenity.firstIndex(of: item.title) {
                                                selectedAmenity.remove(at: index)
                                                selectedAmenityIDs.remove(at: index)
                                            }
                                        }
                                        
                                    }
                            }
                        }
                    }
                    //MARK: Exclude Locations
                    HStack {
                        Text(LocalizedStringKey("Exclude Locations"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    Text(LocalizedStringKey("e.g. Damac Hills"))
                        .font(.roboto_14())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .onTapGesture(){
                            isSearchSheetOpen = true
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 35, maxHeight: 35)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(Color.unselectedBorderColor, lineWidth: 1))
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(excludedLocationArray, id: \.self) { item in
                                HStack {
                                    HStack(alignment: .center, spacing: 0) {
                                        Text(LocalizedStringKey(item))
                                            .font(.roboto_14())
                                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                            .padding(.leading, 3)
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        Image(uiImage: UIImage(named: "close") ?? UIImage())
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.white)
                                            .onTapGesture(){
                                                if let indexToRemove = excludedLocationArray.firstIndex(of: item) {
                                                    excludedLocationArray.remove(at: indexToRemove)
                                                }
                                                
                                            }
                                    }
                                    .background(.black)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(.black )
                                    )
                                }
                                
                            }
                        }
                    }
                    //MARK: Listed By
                    HStack {
                        Text(LocalizedStringKey("Listed By"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(listedByArray, id: \.self) { item in
                                MultiSelectionButton(titleVal: item , isSelected: .constant(selectedListedBy.contains(item)), selectedArray: $selectedListedBy)
                                    .onTapGesture {
                                        if(!selectedListedBy.contains(item)) {
                                            selectedListedBy.append(item)
                                        } else {
                                            if let index = selectedListedBy.firstIndex(of: item) {
                                                selectedListedBy.remove(at: index)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    //MARK: More Filter
                    HStack {
                        Text(LocalizedStringKey("More Filter"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(moreFilterArray, id: \.self) { item in
                                MultiSelectionButton(titleVal: item , isSelected: .constant(selectedMoreFilters.contains(item)), selectedArray: $selectedMoreFilters)
                                    .onTapGesture {
                                        if(!selectedMoreFilters.contains(item)) {
                                            selectedMoreFilters.append(item)
                                        } else {
                                            if let index = selectedMoreFilters.firstIndex(of: item) {
                                                selectedMoreFilters.remove(at: index)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
                Spacer()
                HStack {
                    AppButton(titleVal: "Reset All", isSelected: .constant(false))
                        .onTapGesture {
                            self.clearAllFilter()
                        }
                    AppButton(titleVal: "Show Results", isSelected: .constant(true))
                        .onTapGesture {
                            dataHandler.isLoading = true
                            self.submitFilter()
                        }
                }
                .padding(.bottom, 30)
                
            }
            .padding(.horizontal, 20)
            BottomSheetView(isOpen: $amenityDataHandler.isAmenityChosen,
                            maxHeight: 500) {
                SelectionPopupView(isOpen:  $amenityDataHandler.isAmenityChosen, popupData: $amenityDataHandler.amenityData, selectedArray: $selectedAmenity, selectedAmenityId: $selectedAmenityIDs, valueAmenity: $selectedAmenityIDVal)
                
            }.edgesIgnoringSafeArea(.all)
                .frame(width: .screenWidth,
                       height:  amenityDataHandler.isAmenityChosen ? .screenHeight   : 0.0,
                       alignment: .bottom)
                .opacity( amenityDataHandler.isAmenityChosen ? 1.0 : 0.0)
            
            
        }
        .sheet(isPresented: $isSearchSheetOpen) {
            LocationSearchView(isOpen: $isSearchSheetOpen,
                               selectedLocationArray: $selectedLocationArray
            )
        }
        .frame(width: .screenWidth, height: .screenHeight * 0.8)
        .background(Color.appBackgroundColor)
        .cornerRadius(40, corners: [.topLeft, .topRight])
        .clipped()
        
        .onAppear() {
            dataHandler.getCategoryList(request: HomeViewModel.MakeCategoryRequest.Request(catId: catId, showOnScreen: 0), isFrom: "main category")
            amenityDataHandler.getAmenityList(isFromFilter: true)
            numberFormatter.numberStyle = .decimal
        }
        
        .onChange(of: dataHandler.categoryObjectList) { newCatList in
            if let fistCatId = newCatList.first?.id {
                selectedParentCatId = fistCatId
                dataHandler.getCategoryList(request: HomeViewModel.MakeCategoryRequest.Request(catId: Int(fistCatId), showOnScreen: 0), isFrom: "sub category")
            }
            
        }
        
        .onChange(of: selectedParentCatId) { newID in
            dataHandler.getCategoryList(request: HomeViewModel.MakeCategoryRequest.Request(catId: Int(newID), showOnScreen: 0), isFrom: "sub category")
        }
    }
    
    private  func clearAllFilter() {
        selectedSubCatId = ""
        self.priceSlider.resetSliderValues()
        self.areaSlider.resetSliderValues()
        selectedBedroom = 0
        selectedBathroom = 0
        isStudioSelected = false
        selectedFurnished = .all
        selectedAmenity = []
        selectedAmenityIDs = []
        selectedAmenityIDVal = ""
        excludedLocationArray = []
        selectedListedBy = []
        selectedMoreFilters = []
        lowValueText = "0"
        upperValueText = "99999999"
        lowSizeText = "0"
        upperSizeText = "9999999"
    }
    
    private func submitFilter() {
        argsDictionary = [
            "category_id": selectedSubCatId != "" ? selectedSubCatId : selectedParentCatId,
            "start_price": self.lowValueText,
            "end_price": self.upperValueText,
            "bedrooms": isStudioSelected == true ? "studio" : (selectedBedroom > 0 ? "\(selectedBedroom)" : nil ),
            "bathrooms": selectedBathroom > 0 ? "\(selectedBathroom)" : nil,
            "area_start": lowSizeText,
            "area_end": upperSizeText,
            "furnished": selectedFurnished.stringValue,
            "amenities": selectedAmenityIDVal,
            "exclude_locations" : excludedLocationArray.joined(separator: ",") ,
            "posted_by": selectedListedBy.joined(separator: ","),
            "is_ads_with_video": selectedMoreFilters.contains("Ads with Video") ? "true" : "false" ,
            "is_with_360 ": selectedMoreFilters.contains("Ads with 360 Tour") ? "true" : "false"
        ]
        isOpen.toggle()
    }
}
