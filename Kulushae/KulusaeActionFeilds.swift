//
//  KulusaeActionFeilds.swift
//  Kulushae
//
//  Created by ios on 28/10/2023.
//

import SwiftUI

struct KulushaeActionFields: View {
    @EnvironmentObject var languageManager: LanguageManager
    var placeholder: String = ""
    var fieldType: KulushaeActionFieldType
    var imageName: String = ""
    var fieldName: String = ""
    var spacingBetweenItems: CGFloat = 10
    var font: Font? = .custom(.robotoRegular, size: 16)
    //    @Binding var actionFieldEntry: String
    @Binding var selectedDate: String
    var items: [String]
    @State private var selectedRowId: String = "-1"
    @State private var isSelecting = false
    @State private var selectedValue = ""
    @State var textValue: String = ""
    @State var textViewTitle = ""
    @State var radioTitle: [Option] = []
    @State  var isEnableExtraTitle = false
    @State  var extraImage: String = "question"
    @State  var extraInfo: String = "help"
    @Binding var isDatePickerShowing: Bool
    @State private var displayComponents: DatePickerComponents = [.date]
    @State var dateValue: String = ""
    @State private var isPopoverVisible = false
    
    @State var selectedRadioOption: String = ""
    @State private var isDropdownVisible: Bool = false
    @State private var selectedOption: String = ""
    //    @State private var isPresentDropDown: Bool = false
    
    @FocusState private var isFocused: Bool
    private var borderColor: Color {
        isFocused ? .black : .unselectedBorderColor
    }
    
    let index: Int
    let didGetValue: (Int, String, String, String) -> Void
    
    var body: some View {
        ZStack {
            VStack {
                if(textViewTitle != "") {
                    HStack {
                        if(isEnableExtraTitle) {
                            Spacer()
                        }
                        VStack {
                            HStack {
                                Text(LocalizedStringKey(textViewTitle))
                                    .font(.roboto_16())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                if(isEnableExtraTitle) {
                                    Image(extraImage)
                                        .onTapGesture {
                                            isPopoverVisible.toggle()
                                        }
                                }
                                
                            }
                            
                            if isPopoverVisible {
                                //                                PopoverView(text: "This is a tooltip.")
                            }
                        }
                        
                        if(!isEnableExtraTitle) {
                            Spacer()
                        }
                        
                    }
                    .padding(.top, 12)
                }
                HStack(alignment: fieldType == .dropDown ? .top : .center,
                       spacing: imageName.isEmpty ? 0 : spacingBetweenItems) {
                    if !imageName.isEmpty {
                        Image(uiImage: (UIImage(named: imageName) ?? UIImage(named: "default_ic"))!)
                            .fixedSize()
                            .foregroundColor(Color.gray)
                            .scaledToFit()
                            .frame(width: 18,
                                   alignment: .center)
                            .offset(y: fieldType == .dropDown ? 18 : 0)
                    }
                    
                    switch fieldType {
                    case .dropDown:
                        //                        ZStack(alignment: .leading) {
                        //                            VStack(alignment: .leading, spacing: 1) {
                        //                                // Placeholder
                        //                                Text(LocalizedStringKey(placeholder))
                        //                                    .foregroundColor(Color.black)
                        //                                    .scaleEffect(textValue.isEmpty ? 1.0 : 0.8, anchor: .leading)
                        //                                    .animation(.spring(), value: textValue.isEmpty)
                        //                                    .padding(.horizontal, textValue.isEmpty ? 0 : 8)
                        //                                    .background(.white)
                        //                                    .offset(y: textValue.isEmpty ? 0 : -15)
                        //                                Picker("choose \(placeholder)", selection: $selectedOption) {
                        //                                    ForEach(items, id: \.self) { item in
                        //                                        HStack {
                        //                                            Text(item)
                        //                                                .modifier(PickerTextPadding())
                        //                                                .offset(y: textValue.isEmpty ? -10 : -10)
                        //                                            Spacer()
                        //                                        }
                        //                                    }
                        //                                }
                        //                                .pickerStyle(MenuPickerStyle())
                        //                                .accentColor(.black)
                        //                                .labelsHidden()
                        //                                .onChange(of: selectedOption) { _ in
                        //                                    didGetValue(index, selectedOption, "", "")
                        //                                }
                        //                            }
                        //                        }
                        //                        .font(font)
                        //                        .disableAutocorrection(true)
                        //                        .textInputAutocapitalization(.never)
                        //                        .frame(height: 40, alignment: .center)
                        //
                        //                        Spacer()
                        ZStack(alignment: .top) {
                            VStack {
                                HStack {
                                    ZStack(alignment: .leading) {
                                        VStack(alignment: .leading, spacing: 1) {
                                            // Placeholder
                                            Text(LocalizedStringKey(placeholder))
                                                .foregroundColor(Color.gray)
                                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                                .scaleEffect(textValue.isEmpty ? 1.0 : 0.8, anchor: .leading)
                                                .animation(.spring(), value: textValue.isEmpty)
                                                .padding(.horizontal, textValue.isEmpty ? 0 : 8)
                                                .background(.white)
                                                .offset(y: textValue.isEmpty ? 0 : -20)
                                            Text(textValue.isEmpty ? "" : textValue)
                                                .foregroundColor(textValue.isEmpty ? .gray : .black)
                                                .frame(height: textValue.isEmpty ? 0.0 : nil)
                                                .offset(y: textValue.isEmpty ? -10 : 0)
                                        }
                                    }
                                    .font(font)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .frame(alignment: .center)
                                    
                                    Spacer()
                                    
                                    Image("down_arrow_ic")
                                        .scaledToFit()
                                        .frame(width: 24,
                                               height: 24,
                                               alignment: .center)
                                        .rotationEffect(.degrees( isSelecting ? -180 : 0))
                                    
                                }
                                // .padding(.horizontal)
                                .foregroundColor(.white)
                                
                                //                                if isSelecting {
                                //                                    Divider()
                                //                                        .background(Color.white)
                                //                                        .padding(.horizontal)
                                //
                                //                                    VStack(spacing: 5) {
                                //                                        ScrollView {
                                //                                            ForEach(items, id: \.self) { item in
                                //                                                Button(action: {
                                //                                                    textValue = item
                                //                                                    selectedValue = item
                                //                                                    isSelecting.toggle()
                                //                                                }) {
                                //                                                    HStack {
                                //                                                        Text(LocalizedStringKey(item))
                                //                                                            .padding()
                                //                                                            .foregroundColor(Color.black)
                                //                                                            .font(.roboto_14())
                                //                                                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                //                                                        Spacer()
                                //                                                    }
                                //                                                }
                                //                                            }
                                //                                        }
                                //                                    }
                                //                                    .background(Color.unselectedTextBackgroundColor)
                                //                                }
                            }
                            //                            .frame(height: isSelecting ? CGFloat((items.count > 3 ? 240 : ((items.count <= 2) ? items.count * 85 : items.count * 75))) : 5)
                            //                            .padding(isSelecting ? .top : .vertical)
                            .frame(height: 5)
                            .padding(.vertical)
                            .onTapGesture {
                                isSelecting = true
                                //                                isSelecting.toggle()
                            }
                            .onChange(of: isSelecting) { popUpShown in
                                if !popUpShown {
                                    didGetValue(0, selectedValue, "", "")
                                }
                            }
                            .animation(.easeInOut(duration: 0.3))
                        }
                        
                    case .datePickerType, .timePicker, .dateNTimePicker:
                        Button {
                            isDatePickerShowing = true
                        } label: {
                            ZStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(LocalizedStringKey(placeholder))
                                        .foregroundColor(Color.gray)
                                        .font(.roboto_14())
                                        .scaleEffect(dateValue.isEmpty ? 1.0 : 0.9, anchor: .leading)
                                        .animation(.spring(), value: dateValue.isEmpty)
                                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                        .padding(.horizontal, textValue.isEmpty ? 0 : 8)
                                        .background(.white)
                                        .offset(y: dateValue.isEmpty ? 0 : -24)
                                    
                                    Text(dateValue.isEmpty ? "" : dateValue)
                                        .foregroundColor(dateValue.isEmpty ? Color.gray : .black)
                                        .frame(height: dateValue.isEmpty ? 0.0 : nil)
                                        .font(.roboto_14())
                                        .offset(y: textValue.isEmpty ? -10 : -10)
                                    
                                }
                            }
                            .font(font)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .frame(height: 40,
                                   alignment: .center)
                            Spacer()
                            
                            Image("calendar")
                                .scaledToFit()
                                .frame(width: 24,
                                       height: 24,
                                       alignment: .center)
                        }
                        .onChange(of: selectedDate) { _ in
                            dateValue = selectedDate
                            didGetValue(index, dateValue, "", "")
                        }
                        
                        Spacer()
                        
                    case .textVal:
                        ZStack(alignment: .leading) {
                            
                            VStack(alignment: .leading, spacing: 1) {
                                // Placeholder
                                Text(LocalizedStringKey(placeholder))
                                    .foregroundColor(Color.gray)
                                    .font(.roboto_14())
                                    .scaleEffect(textValue.isEmpty ? 1.0 : 0.9, anchor: .leading)
                                    .animation(.spring(), value: textValue.isEmpty)
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                    .padding(.horizontal, textValue.isEmpty ? 0 : 8)
                                    .offset(y: textValue.isEmpty ? 0 : -20)
                                    .background(.white)
                                TextField("", text: $textValue)
                                    .onChange(of: textValue) { newValue in
                                        if self.fieldType != .map_searchable {
                                            didGetValue(index, newValue, "", "")
                                        }
                                    }
                                    .font(.roboto_14())
                                    .foregroundColor(.black)
                                    .frame(height: textValue.isEmpty ? 0.0 : nil)
                                    .offset(y: textValue.isEmpty ? -10 : -10)
                                    .focused($isFocused)
                            }
                            
                        }
                        .font(font)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .frame(height: 40, alignment: .center)
                        
                        Spacer()
                        
                    case .intText:
                        ZStack(alignment: .leading) {
                            
                            VStack(alignment: .leading, spacing: 1) {
                                // Placeholder
                                Text(LocalizedStringKey(placeholder))
                                    .foregroundColor(Color.gray)
                                    .scaleEffect(textValue.isEmpty ? 1.0 : 0.8, anchor: .leading)
                                    .animation(.spring(), value: textValue.isEmpty)
                                    .padding(.horizontal, textValue.isEmpty ? 0 : -10)
                                    .background(.white)
                                    .offset(y: textValue.isEmpty ? 0 : -20)
                                    .zIndex(2.0)
                                TextField("", text: $textValue)
                                    .onChange(of: textValue) { newValue in
                                        didGetValue(index, newValue, "", "")
                                    }
                                    .foregroundColor(.black)
                                    .frame(height: textValue.isEmpty ? 0.0 : nil)
                                    .offset(y: textValue.isEmpty ? -10 : -10)
                                    .focused($isFocused)
                                
                            }
                            
                        }
                        .font(font)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .frame(height: 40, alignment: .center)
                        .keyboardType(fieldName.lowercased() == "mobileno" ? .phonePad : .numberPad)
                        
                        Spacer()
                        
                    case .decimal:
                        ZStack(alignment: .leading) {
                            
                            VStack(alignment: .leading, spacing: 1) {
                                // Placeholder
                                Text(LocalizedStringKey(placeholder))
                                    .foregroundColor(Color.gray)
                                    .padding(.horizontal, textValue.isEmpty ? 0 : 8)
                                    .background(.white)
                                    .scaleEffect(textValue.isEmpty ? 1.0 : 0.9, anchor: .leading)
                                    .animation(.spring(), value: textValue.isEmpty)
                                    .offset(y: textValue.isEmpty ? 0 : -20)
                                TextField("", text: $textValue)
                                    .onChange(of: textValue) { newValue in
                                        didGetValue(index, newValue, "", "")
                                    }
                                    .foregroundColor(.black)
                                    .frame(height: textValue.isEmpty ? 0.0 : nil)
                                    .offset(y: textValue.isEmpty ? -10 : 0)
                                    .focused($isFocused)
                            }
                            
                        }
                        .font(font)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .frame(height: 40, alignment: .center)
                        .keyboardType(.decimalPad)
                        
                        Spacer()
                        
                    case .price:
                        ZStack(alignment: .leading) {
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 1) {
                                    // Placeholder
                                    Text(LocalizedStringKey(placeholder))
                                        .foregroundColor(Color.gray)
                                        .font(.roboto_14())
                                        .scaleEffect(textValue.isEmpty ? 1.0 : 0.9, anchor: .leading)
                                        .animation(.spring(), value: textValue.isEmpty)
                                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                        .padding(.horizontal, textValue.isEmpty ? 0 : 8)
                                        .background(.white)
                                        .offset(y: textValue.isEmpty ? 0 : -20)
                                    TextField("", text: $textValue)
                                    //                                        .keyboardType(.decimalPad)
                                        .onChange(of: textValue) { newValue in
                                            didGetValue(index, newValue, "", "")
                                        }
                                        .font(.roboto_14())
                                        .foregroundColor(.black)
                                        .frame(height: textValue.isEmpty ? 0.0 : nil)
                                        .offset(y: textValue.isEmpty ? -10 : -10)
                                        .focused($isFocused)
                                }
                                Spacer()
                                Text("\(UserDefaultManager.get(.chosenCurrency) ?? "")")
                                    .font(.roboto_14())
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                    .foregroundColor(Color.gray)
                                    .padding(.trailing, 15)
                            }
                            
                        }
                        .font(font)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .frame(height: 40, alignment: .center)
                        
                        Spacer()
                    case .textView:
                        TextEditor(text: $textValue)
                            .onChange(of: textValue) { newValue in
                                didGetValue(index, newValue, "", "")
                            }
                            .font(.roboto_14())
                            .foregroundColor(Color.black)
                            .focused($isFocused)
                            .frame(height: 112)
                    case .radio:
                        ZStack {
                            VStack(spacing: 10) {
                                HStack {
                                    Text(LocalizedStringKey(placeholder))
                                        .foregroundColor(Color.black)
                                        .font(.roboto_16())
                                        .fontWeight(.bold)
                                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                        .padding(.horizontal, textValue.isEmpty ? 0 : 8)
                                        .background(.white)
                                    Spacer()
                                }
                                
                                HStack {
                                    RadioButtonView(title: radioTitle[0].text, selectedVal: $selectedRadioOption)
                                        .padding(.trailing, 15)
                                    RadioButtonView(title: radioTitle[1].text , selectedVal: $selectedRadioOption)
                                }
                            }
                            .onChange(of: selectedRadioOption) { newValue in
                                for item in radioTitle {
                                    if(item.text == newValue) {
                                        let valueAsString: String
                                        
                                        switch item.value {
                                        case .intValue(let intValue):
                                            valueAsString = String(intValue)
                                        case .doubleValue(let doubleValue):
                                            valueAsString = String(doubleValue)
                                        case .stringValue(let stringValue):
                                            valueAsString = stringValue
                                        case .boolValue(let boolValue):
                                            valueAsString = String(boolValue)
                                        }
                                        didGetValue(index, valueAsString , "", "")
                                    }
                                }
                            }
                        }
                        .font(font)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .frame(height: 40, alignment: .center)
                        Spacer()
                    case .selectionType:
                        ZStack {
                            HStack(spacing: 10) {
                                Text(LocalizedStringKey(placeholder))
                                    .foregroundColor(Color.black)
                                    .font(.roboto_16())
                                    .fontWeight(.bold)
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                    .padding(.horizontal, textValue.isEmpty ? 0 : 8)
                                    .background(.white)
                                Spacer()
                                Image("arrow_top_down")
                            }
                            
                        }
                        .onTapGesture() {
                            didGetValue(index, "", "", "")
                        }
                        .font(font)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .frame(height: 40, alignment: .center)
                        Spacer()
                    case  .map_searchable:
                        ZStack(alignment: .leading) {
                            
                            VStack(alignment: .leading, spacing: 1) {
                                // Placeholder
                                Text(LocalizedStringKey(placeholder))
                                    .foregroundColor(Color.gray)
                                    .font(.roboto_14())
                                    .scaleEffect(selectedDate.isEmpty ? 1.0 : 0.9, anchor: .leading)
                                    .animation(.spring(), value: selectedDate.isEmpty)
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                    .background(.white)
                                    .offset(y: selectedDate.isEmpty ? 0 : -20)
                                TextField(selectedDate, text: $selectedDate)
                                    .onChange(of: selectedDate) { newValue in
                                        didGetValue(index, newValue, "", "")
                                    }
                                    .font(.roboto_14())
                                    .foregroundColor(.black)
                                    .frame(height: selectedDate.isEmpty ? 0.0 : nil)
                                    .offset(y: selectedDate.isEmpty ? -10 : -10)
                                    .focused($isFocused)
                            }
                            
                        }
                        .font(font)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .frame(height: 40, alignment: .center)
                        
                        Spacer()
                        
                    }
                    
                }
                       .padding(.all, 10)
                       .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(borderColor,
                                    lineWidth: fieldType == .radio ? 0 : 1))
                            .padding(.horizontal, 1)
                       )
            }
            
        }
        .fullScreenCover(isPresented: $isSelecting) {
            FormDropDownOptionsPopup(placeholder: placeholder, items: items) { item in
                if let item {
                    textValue = item
                    selectedValue = item
                }
                
                isSelecting = false
            }
            .clearBackground()
        }
    }
    
}
struct PickerTextPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.trailing, 20) // Adjust the value to increase or decrease the space
    }
}

//struct DropdownMenuItemView: View {
//    @Binding var isSelecting: Bool
//    @Binding var selectionId: String
//    @Binding var selectiontitle: String
//    @Binding var seclectedValue: String
//    let item: DropdownItem
//
//    var body: some View {
//        Button {
//            isSelecting = false
//            selectionId = item.id
//            selectiontitle = item.title
//            seclectedValue = item.value
//            item.onSelect()
//        } label: {
//            HStack {
//                Text(item.title)
//                    .font(.roboto_14())
//                    .foregroundColor(.white)
//                    .padding(.leading)
//
//                Spacer()
//            }
//            .frame(height: 50)
//            .background(selectionId == item.id ? Color.unselectedTextBackgroundColor : Color.unselectedTextBackgroundColor)
//            .cornerRadius(10)
//            .animation(.spring(), value: selectionId == item.id)
//
//        }
//
//        .onAppear {
//            print(item.id)
//        }
//    }
//}
//struct DropdownItem: Identifiable, Equatable {
//    static func == (lhs: DropdownItem, rhs: DropdownItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//
//    let id: String
//    let title: String
//    let value: String
//    let onSelect: () -> Void
//
//    init(id: String, title: String, value: String, onSelect: @escaping () -> Void) {
//        self.id = id
//        self.title = title
//        self.onSelect = onSelect
//        self.value = value
//    }
//
//    init() {
//        self.id = "-1"
//        self.title = ""
//        self.value = ""
//        self.onSelect = { }
//    }
//
//}
