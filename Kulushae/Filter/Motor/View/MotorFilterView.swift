//
//  MotorFilterView.swift
//  Kulushae
//
//  Created by ios on 17/04/2024.
//

import SwiftUI
import MapboxSearch
import Combine

struct MotorFilterView: View {
    @Binding var argsDictionary: [String: String?]
    @Binding var isOpen: Bool
    @EnvironmentObject var languageManager: LanguageManager
    @State var catId : Int
    @StateObject var dataHandler = HomeViewModel.ViewModel()
    @ObservedObject var yearSlider = CustomSlider(start: 1990, end: 2024)
    @State  var locationArray:[String]  = ["All", "Dubai", "Ajman", "Sharjah", "Abu Dhabi", "Fujairah" , "Umm Al Quwain", "Ras Al Khaimah", "Al Ain"]
    @State  var typesArray:[String]  = ["SUV", "Coupe","Sedan","Crossover","Hard Top Convertible","Soft Top Convertible","Pick Up Truck","Hatchback","Sports Car","Van", "Wagon","Utility Truck"]
    @State  var seatList:[String]  = ["2 Seater", "4 Seater", "5 Seater", "6 seater", "7 Seater"]
    @State  var transmissionList:[String]  = ["Manual Transmission", "Automatic Transmission"]
    @State  var selectedTransmissionArray:[String] = []
    @State  var fuelList:[String]  = ["Petrol", "Diesel", "Hybrid", "Electric"]
    @State  var selectedFuelArray:[String] = []
    @State  var horsePowerList:[String]  = ["0 - 99 HP", "100 - 199 HP", "200 - 299 HP", "300 - 399 HP", "400 - 499 HP"]
    @State  var selectedhorsePowerArray:[String] = []
    @State  var enginCapacityList:[String]  = ["0 - 499 cc", "500 - 999 cc", "1000 - 1499 cc", "1500 - 1999 cc", "2000 - 2499 cc"]
    @State  var selectedEnginArray:[String] = []
    @State  var doorsList:[String]  = ["2 Doors", "3 Doors", "4 Doors", "5+ Doors"]
    @State  var selectedDoorArray:[String] = []
    @State  var cylenderList:[String]  = ["3", "4", "5", "6", "8", "10", "12"]
    @State  var selectedCylenderArray:[String] = []
    @State  var stearingSideList:[String]  = ["Left Hand", "Right Hand"]
    @State  var selectedSteerArray:[String] = []
    @State  var selectedLocationArray:[String]  = []
    @State  var selectedSeatsArray:[String] = []
    @State private var isSearchSheetOpen: Bool = false
    @StateObject var priceSlider = CustomSlider(start: 3000, end: 9999999)
    @State var lowValueText = "0"
    @State var upperValueText = "99999999"
    @State var lowYearText = "1995"
    @State var upperYearText = "2024"
    let numberFormatter = NumberFormatter()
    @State var searchKey: String = ""
    @State var selectedType: String = ""
    @StateObject var filterDataHandler = MotorFilterViewModel.ViewModel()
    @State var selectedMAkeId: String = "-1"
    @State var selectedModelId: String = "-1"
    
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
                ScrollView {
                    HStack {
                        Text(LocalizedStringKey("Cities"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .frame(height: 18)
                    .padding(.vertical)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(locationArray, id: \.self) { item in
                                MultiSelectionButton(titleVal: item , isSelected: .constant(selectedLocationArray.contains(item)), selectedArray: $selectedLocationArray)
                                    .onTapGesture {
                                        if(!selectedLocationArray.contains(item)) {
                                            selectedLocationArray.append(item)
                                        } else {
                                            if let index = selectedLocationArray.firstIndex(of: item) {
                                                selectedLocationArray.remove(at: index)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    
                    KulushaeActionFields(placeholder: "Make" ,
                                         fieldType: .dropDown,
                                         imageName: "",
                                         selectedDate: .constant(""),
                                         items: filterDataHandler.motorMakeListName,
                                         textValue: "",
                                         textViewTitle:  "",
                                         isEnableExtraTitle: false ,
                                         isDatePickerShowing: .constant(false),
                                         index: 0,
                                         didGetValue: { _ , actionValue, _ , _ in
                        hideKeyboard()
                        if let id =  filterDataHandler.motorMakeList.first(where: { $0.title == actionValue })?.id {
                            filterDataHandler.getMotorModel(makeId: id)
                            DispatchQueue.main.async() {
                                selectedMAkeId = id
                            }
                        }
                    })
                    .keyboardType(.default)
                    .onTapGesture(){
                        hideKeyboard()
                    }
                    .padding(.all, 15)
                    if(selectedMAkeId != "-1") {
                        KulushaeActionFields(placeholder: "Model" ,
                                             fieldType: .dropDown,
                                             imageName: "",
                                             selectedDate: .constant(""),
                                             items: filterDataHandler.motorModelListName,
                                             textValue: "",
                                             textViewTitle:  "",
                                             isEnableExtraTitle: false ,
                                             isDatePickerShowing: .constant(false),
                                             index: 0,
                                             didGetValue: { _ , actionValue, _ , _ in
                            hideKeyboard()
                            if let id =  filterDataHandler.motorModelList.first(where: { $0.title == actionValue })?.id {
                                DispatchQueue.main.async() {
                                    selectedModelId = id
                                }
                            }
                        })
                        .keyboardType(.default)
                        .onTapGesture(){
                            hideKeyboard()
                        }
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)
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
                                    .frame(width: 50)
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
                    
                    //MARK: Year
                    HStack {
                        Text(LocalizedStringKey("Types"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .frame(height: 18)
                    .padding(.vertical)
                    
                    ForEach(typesArray.chunked(into: 2), id: \.self) { types in
                        HStack(spacing: 10) {
                            ForEach(types, id: \.self) { type in
                                HStack {
                                    MultiRadioView(item: type, selectedItem: $selectedType)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    HStack {
                        Text(LocalizedStringKey("Year"))
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
                                TextField("1995", text: $lowYearText)
                                    .font(.roboto_14())
                                    .onChange(of: lowYearText) { newValue in
                                        if let newValue = Double(newValue) {
                                            let normalizedValue = min(max(0.0, newValue / (yearSlider.valueEnd - yearSlider.valueStart)), 1.0)
                                            
                                            // Update slider handles directly, ensuring consistency:
                                            yearSlider.lowHandle.currentPercentage.wrappedValue = normalizedValue
                                            if normalizedValue > yearSlider.highHandle.currentPercentage.wrappedValue {
                                                yearSlider.highHandle.currentPercentage.wrappedValue = normalizedValue
                                            }
                                            yearSlider.updateHandleLocations()
                                            // Trigger notification for visual updates:
                                            yearSlider.objectWillChange.send()
                                        }
                                    }
                                    .textFieldStyle(PlainTextFieldStyle()) // Use PlainTextFieldStyle to remove border
                                    .padding()
                                    .keyboardType(.decimalPad)
                            }
                            .frame(height: 50)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.5)
                                .stroke(Color.unselectedBorderColor, lineWidth: 1))
                            HStack {
                                Text("-")
                                    .font(.roboto_14())
                                    .padding()
                                    .frame(width: 50)
                            }
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.5)
                                .stroke(Color.unselectedBorderColor, lineWidth: 1))
                            ZStack(alignment: .trailing) {
                                TextField("2024", text: $upperYearText)
                                    .font(.roboto_14())
                                    .onChange(of: upperYearText) { newValue in
                                        if let newValue = Double(newValue) {
                                            let normalizedValue = min(max(0.0, newValue / (yearSlider.valueEnd - yearSlider.valueStart)), 1.0)
                                            
                                            yearSlider.highHandle.currentPercentage.wrappedValue = normalizedValue
                                            if normalizedValue < yearSlider.lowHandle.currentPercentage.wrappedValue {
                                                yearSlider.lowHandle.currentPercentage.wrappedValue = normalizedValue
                                            }
                                            
                                            yearSlider.updateHandleLocations()
                                            yearSlider.objectWillChange.send()
                                        }
                                    }
                                    .textFieldStyle(PlainTextFieldStyle()) // Use PlainTextFieldStyle to remove border
                                    .padding()
                                    .keyboardType(.decimalPad)
                            }
                            .frame(height: 50)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.5)
                                .stroke(Color.unselectedBorderColor, lineWidth: 1))
                            Spacer()
                        }
                    }
                    //Slider
                    SliderView(slider: yearSlider)
                        .padding(.vertical)
                        .onReceive(yearSlider.lowHandle.$onDrag) { onDrag in
                            if onDrag {
                                lowYearText = String(Int( yearSlider.lowHandle.currentValue))
                            }
                        }
                        .onReceive(yearSlider.highHandle.$onDrag) { onDrag in
                            if onDrag {
                                upperYearText = String(Int( yearSlider.highHandle.currentValue))
                            }
                        }
                    
                    //MARK: Seat
                    HStack {
                        Text(LocalizedStringKey("Seats"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(seatList, id: \.self) { item in
                                MultiSelectionButton(titleVal: item , isSelected: .constant(selectedSeatsArray.contains(item)), selectedArray: $selectedSeatsArray)
                                    .onTapGesture {
                                        if(!selectedSeatsArray.contains(item)) {
                                            selectedSeatsArray.append(item)
                                        } else {
                                            if let index = selectedSeatsArray.firstIndex(of: item) {
                                                selectedSeatsArray.remove(at: index)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    
                    //MARK: transmission Type
                    HStack {
                        Text(LocalizedStringKey("Transmission type"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(transmissionList, id: \.self) { item in
                                MultiSelectionButton(titleVal: item , isSelected: .constant(selectedTransmissionArray.contains(item)), selectedArray: $selectedTransmissionArray)
                                    .onTapGesture {
                                        if(!selectedTransmissionArray.contains(item)) {
                                            selectedTransmissionArray.append(item)
                                        } else {
                                            if let index = selectedTransmissionArray.firstIndex(of: item) {
                                                selectedTransmissionArray.remove(at: index)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    
                    //MARK: Fuel Type
                    HStack {
                        Text(LocalizedStringKey("Fuel type"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(fuelList, id: \.self) { item in
                                MultiSelectionButton(titleVal: item , isSelected: .constant(selectedFuelArray.contains(item)), selectedArray: $selectedFuelArray)
                                    .onTapGesture {
                                        if(!selectedFuelArray.contains(item)) {
                                            selectedFuelArray.append(item)
                                        } else {
                                            if let index = selectedFuelArray.firstIndex(of: item) {
                                                selectedFuelArray.remove(at: index)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    //MARK: Horsepower
                    HStack {
                        Text(LocalizedStringKey("Horsepower"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(horsePowerList, id: \.self) { item in
                                MultiSelectionButton(titleVal: item , isSelected: .constant(selectedhorsePowerArray.contains(item)), selectedArray: $selectedhorsePowerArray)
                                    .onTapGesture {
                                        if(!selectedhorsePowerArray.contains(item)) {
                                            selectedhorsePowerArray.append(item)
                                        } else {
                                            if let index = selectedhorsePowerArray.firstIndex(of: item) {
                                                selectedhorsePowerArray.remove(at: index)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    
                    //MARK: Engine Capacity
                    HStack {
                        Text(LocalizedStringKey("Engine Capacity"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(enginCapacityList, id: \.self) { item in
                                MultiSelectionButton(titleVal: item , isSelected: .constant(selectedEnginArray.contains(item)), selectedArray: $selectedEnginArray)
                                    .onTapGesture {
                                        if(!selectedEnginArray.contains(item)) {
                                            selectedEnginArray.append(item)
                                        } else {
                                            if let index = selectedEnginArray.firstIndex(of: item) {
                                                selectedEnginArray.remove(at: index)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    //MARK: Doors
                    HStack {
                        Text(LocalizedStringKey("Doors"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(doorsList, id: \.self) { item in
                                MultiSelectionButton(titleVal: item , isSelected: .constant(selectedDoorArray.contains(item)), selectedArray: $selectedDoorArray)
                                    .onTapGesture {
                                        if(!selectedDoorArray.contains(item)) {
                                            selectedDoorArray.append(item)
                                        } else {
                                            if let index = selectedDoorArray.firstIndex(of: item) {
                                                selectedDoorArray.remove(at: index)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    //MARK: Number of Cylinder
                    HStack {
                        Text(LocalizedStringKey("Number of Cylinder"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(cylenderList, id: \.self) { item in
                                MultiSelectionButton(titleVal: item , isSelected: .constant(selectedCylenderArray.contains(item)), selectedArray: $selectedCylenderArray)
                                    .onTapGesture {
                                        if(!selectedCylenderArray.contains(item)) {
                                            selectedCylenderArray.append(item)
                                        } else {
                                            if let index = selectedCylenderArray.firstIndex(of: item) {
                                                selectedCylenderArray.remove(at: index)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    //MARK: Steering Side
                    HStack {
                        Text(LocalizedStringKey("Steering Side"))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .padding(.vertical)
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(stearingSideList, id: \.self) { item in
                                MultiSelectionButton(titleVal: item , isSelected: .constant(selectedSteerArray.contains(item)), selectedArray: $selectedSteerArray)
                                    .onTapGesture {
                                        if(!selectedSteerArray.contains(item)) {
                                            selectedSteerArray.append(item)
                                        } else {
                                            if let index = selectedSteerArray.firstIndex(of: item) {
                                                selectedSteerArray.remove(at: index)
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(.bottom)
                    }
                    Spacer()
                    
                }
                HStack {
                    AppButton(titleVal: "Reset All", isSelected: .constant(false))
                        .onTapGesture {
                            self.clearAllFilter()
                        }
                    AppButton(titleVal: "Show Results", isSelected: .constant(true))
                        .onTapGesture {
                            dataHandler.isCarLoading = true
                            self.submitFilter()
                        }
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 15)
        }
        .frame(width: .screenWidth, height: .screenHeight * 0.8)
        .background(Color.appBackgroundColor)
        .cornerRadius(40, corners: [.topLeft, .topRight])
        .clipped()
        .onAppear() {
            filterDataHandler.getMotorMake()
        }
        
    }
    private  func clearAllFilter() {
        self.priceSlider.resetSliderValues()
        self.yearSlider.resetSliderValues()
        selectedLocationArray = []
        selectedType = ""
        selectedSeatsArray = []
        selectedTransmissionArray = []
        selectedFuelArray = []
        selectedhorsePowerArray = []
        selectedEnginArray = []
        selectedDoorArray = []
        selectedCylenderArray = []
        lowValueText = "0"
        upperValueText = "99999999"
        lowYearText = "1995"
        upperYearText = "2024"
        selectedSteerArray = []
        selectedMAkeId = "-1"
        selectedModelId = "-1"
    }
    
    private func submitFilter() {
        argsDictionary = [
            "category_id": "",
            "start_price": self.lowValueText,
            "end_price": self.upperValueText,
            "start_year": self.lowYearText,
            "end_year": self.upperYearText,
            "cities": selectedLocationArray.joined(separator: ","),
            "type": selectedType,
            "seats": selectedSeatsArray.joined(separator: ","),
            "transmissionType": selectedTransmissionArray.joined(separator: ","),
            "fuelType": selectedFuelArray.joined(separator: ","),
            "horsePower": selectedhorsePowerArray.joined(separator: ","),
            "engine" : selectedEnginArray.joined(separator: ",") ,
            "doors": selectedDoorArray.joined(separator: ","),
            "cylinder": selectedCylenderArray.joined(separator: ","),
            "steering_side":  selectedSteerArray.joined(separator: ","),
            "model_id": (Int(selectedModelId) ?? -1) > 0 ? selectedModelId : nil,
            "make_id": (Int(selectedMAkeId) ?? -1) > 0 ? selectedMAkeId : nil
        ]
        isOpen.toggle()
    }
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
