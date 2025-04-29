//
//  AdDetailsView.swift
//  Kulushae
//
//  Created by ios on 28/10/2023.
//

//import SwiftUI
//import MapboxSearch
//import CoreLocation
////import StripePaymentSheet
//import PaymentSDK
//
//enum ImageSource {
//    case gallery
//    case camera
//    case notSelected
//}
//
////struct imageModel: Equatable {
////    var name: UIImage
////    var fileName: String
////    var url :String?
////}
//
//struct MediaModel: Equatable {
//    enum MediaType {
//        case image(UIImage)
//        case video(URL)
//    }
//    
//    var media: MediaType
//    var fileName: String
//    var url: String?
//    
//    init(image: UIImage, fileName: String, url: String? = nil) {
//        self.media = .image(image)
//        self.fileName = fileName
//        self.url = url
//    }
//    
//    init(videoURL: URL, fileName: String, url: String? = nil) {
//        self.media = .video(videoURL)
//        self.fileName = fileName
//        self.url = url
//    }
//    
//    static func == (lhs: MediaModel, rhs: MediaModel) -> Bool {
//        switch (lhs.media, rhs.media) {
//        case (.image(let lhsImage), .image(let rhsImage)):
//            return lhsImage == rhsImage && lhs.fileName == rhs.fileName && lhs.url == rhs.url
//        case (.video(let lhsURL), .video(let rhsURL)):
//            return lhsURL == rhsURL && lhs.fileName == rhs.fileName && lhs.url == rhs.url
//        default:
//            return false
//        }
//    }
//}
//
//struct AdDetailsView: View {
//    @State var openedStates: [Int] = []
//    static var parentCatIdVal: Int = -1
//    @State var newCatIdVal: Int
//    @StateObject var dataHandler = AdDetailsViewModel.ViewModel()
//    @EnvironmentObject var languageManager: LanguageManager
//    static var fieldValueArray: [[String: Any]] = []
//    var titleVal: String  = ""
//    @State var name = ""
//    @State private var selectedImage: UIImage?
//    @State private var showingImagePicker = false
//    @State private var imageSource: ImageSource = .notSelected
//    @State private var uploadedImages: [MediaModel] = []
//    @State private var isOn = false
//    @State var stepNum: Int
//    @State var isOpenNextScreen = false
//    @State var isOpenPaymentScreen = false
//    @State var isNextEnabled = false
//    @State private var dateString: String = ""
//    @State private var isDatePickerShowing: Bool = false
//    @State var selectedDate: Date = Date()
//    @State  var selectedAmenity:[String]  = []
//    @State  var selectedAmenityIDs:[String]  = []
//    @State  var selectedAmenityIDVal: String   = ""
//    @State private var isPopoverPresented: Bool = false
//    @State private var searchQuery: String = ""
//    @StateObject private var searchDelegate = SearchDelegate()
//    @State private var selectedPlace: String = ""
//    //    let geocodingService = GeocodingService()
//    let geocoder = CLGeocoder()
//    @State var selectedLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
//    @State private var showErrorPopup: Bool = false
//    @State private var errMessage: String = ""
//    @State private var isValidates: Bool = false
//    @State private var progress: Double = 0.0
//    @State private var isUploading = false
//    @State var isOpenImageChooseView: Bool = false
//    //    @StateObject var model = StripBackendModel()
//    @State var selectedOption : String = ""
//    @State var action: String = ""
//    @State var imageType = "PROPERTY_IMAGES_URL"
//    @StateObject var paymentDelegate = PaymentDelegate()
//    @State private var isPaymentSuccessful = false
//    @State var fromPayment: Bool = false
//    @State var isHomeOpen: Bool = false
//    @State var selectedMAkeId: String = "-1"
//    @State var selectedStateId: Int = -1
//    @StateObject var filterDataHandler = MotorFilterViewModel.ViewModel()
//    var paymentCallbackURL : String? = "https://webhook.site/0ceb31ee-cdcd-48da-8bd5-d884ae38ee3b"
//    @State var isFullscreenMap: Bool = false
//    
//    @State var phoneCountry = "AE"
//    @State var phoneNumber = "+971"
//    
//    var body: some View {
//        UILoader(isShowing: dataHandler.isLoading) {
//            ZStack(alignment: .bottom) {
//                VStack(spacing: 0) {
//                    NavigationTopBarView(titleVal: titleVal)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    ScrollView {
//                        VStack(spacing: 21) {
//                            ForEach(dataHandler.formData.indices, id: \.self) { indexVal in
//                                let items = dataHandler.formData[indexVal]
//                                
//                                HStack {
//                                    ForEach(items.indices, id: \.self) { index in
//                                        let item = items[index]
//                                        let field_size = (.screenWidth * 0.9 *  CGFloat((item.fieldSize )) / 100  )
//                                        let optionalKey =  (UserDefaults.standard.string(forKey: "AppLanguage") ?? "en") == "en" ? " (optional)" : " (خياري)"
//                                        switch item.fieldType {
//                                        case "text":
//                                            KulushaeActionFields(placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                                                 fieldType: .textVal,
//                                                                 imageName: "",
//                                                                 selectedDate: .constant(""),
//                                                                 items: [],
//                                                                 textValue: "",
//                                                                 textViewTitle: item.fieldExtras.extra_title ?? "",
//                                                                 isEnableExtraTitle: (((item.fieldExtras.extra_title ?? "") == "" ) ? false : true),
//                                                                 isDatePickerShowing: .constant(false),
//                                                                 index: 0,
//                                                                 didGetValue: { _, actionValue, _ , _ in
//                                                dataHandler.formData[indexVal][index].fieldValue = actionValue
//                                                
//                                            })
//                                            .frame(width : field_size)
//                                            .keyboardType(.default)
//                                            //
//                                        case "phone":
//                                            let title = (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "")
//                                            LabelPhoneNumberTextField(
//                                                placeholder: title,
//                                                selectedCountry: $phoneCountry,
//                                                text: $phoneNumber.onChange { newValue in
//                                                    print("** wk phoneCountry: \(phoneCountry), phone: \(newValue)")
//                                                    var phone = newValue//.replaceOccurrences(of: "+", with: "") ?? ""
//                                                    if phone.hasPrefix("+") {
//                                                        phone = trim(phone.dropFirst())
//                                                    }
//                                                    print("** wk phone: \(phone)")
//                                                    dataHandler.formData[indexVal][index].fieldValue = phone
//                                                },
//                                                isEnableExtraTitle: !trim(item.fieldExtras.extra_title).isEmpty
//                                            )
//                                            //                                            KulushaeActionFields(placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                            //                                                                 fieldType: .textVal,
//                                            //                                                                 imageName: "",
//                                            //                                                                 selectedDate: .constant(""),
//                                            //                                                                 items: [],
//                                            //                                                                 textValue: "",
//                                            //                                                                 textViewTitle: item.fieldExtras.extra_title ?? "",
//                                            //                                                                 isEnableExtraTitle: (((item.fieldExtras.extra_title ?? "") == "" ) ? false : true),
//                                            //                                                                 isDatePickerShowing: .constant(false),
//                                            //                                                                 index: 0,
//                                            //                                                                 didGetValue: { _, actionValue, _ , _ in
//                                            //                                                dataHandler.formData[indexVal][index].fieldValue = actionValue
//                                            //
//                                            //                                            })
//                                            //                                            .frame(width : field_size)
//                                            //                                            .keyboardType(.phonePad)
//                                        case "price":
//                                            KulushaeActionFields(placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                                                 fieldType: .price,
//                                                                 imageName: "",
//                                                                 selectedDate: .constant(""),
//                                                                 items: [],
//                                                                 textValue: "",
//                                                                 textViewTitle: item.fieldExtras.extra_title ?? "",
//                                                                 isEnableExtraTitle: (((item.fieldExtras.extra_title ?? "") == "" ) ? false : true),
//                                                                 isDatePickerShowing: .constant(false),
//                                                                 index: 0,
//                                                                 didGetValue: { _, actionValue, _ , _ in
//                                                DispatchQueue.main.async {
//                                                    dataHandler.formData[indexVal][index].fieldValue = actionValue
//                                                }
//                                                
//                                            })
//                                            .frame(width : field_size)
//                                            .keyboardType(.decimalPad)
//                                            
//                                        case "textview":
//                                            KulushaeActionFields(placeholder:  "",
//                                                                 fieldType: .textView,
//                                                                 imageName: "",
//                                                                 selectedDate: .constant(""),
//                                                                 items: [],
//                                                                 textValue:  "",
//                                                                 textViewTitle: item.fieldExtras.title ?? "" + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                                                 isEnableExtraTitle: (((item.fieldExtras.extra_title ?? "") == "" ) ? false : true),
//                                                                 isDatePickerShowing: .constant(false),
//                                                                 index: 0,
//                                                                 didGetValue: { _, actionValue, _ , _ in
//                                                dataHandler.formData[indexVal][index].fieldValue = actionValue
//                                            })
//                                            .frame(width : field_size)
//                                            .keyboardType(.default)
//                                        case "float":
//                                            KulushaeActionFields(placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                                                 fieldType: .textVal,
//                                                                 imageName: "",
//                                                                 selectedDate: .constant(""),
//                                                                 items: [],
//                                                                 textValue: "",
//                                                                 textViewTitle: item.fieldExtras.extra_title ?? "",
//                                                                 isEnableExtraTitle: (((item.fieldExtras.extra_title ?? "") == "" ) ? false : true),
//                                                                 isDatePickerShowing: .constant(false),
//                                                                 index: 0,
//                                                                 didGetValue: { _, actionValue, _ , _ in
//                                                dataHandler.formData[indexVal][index].fieldValue = actionValue
//                                            })
//                                            .frame(width : field_size)
//                                            .keyboardType(.decimalPad)
//                                            //
//                                        case "file":
//                                            HStack {
//                                                VStack {
//                                                    ScrollView(.horizontal, showsIndicators: false) {
//                                                        HStack(spacing: 10) {
//                                                            ForEach(0..<uploadedImages.count, id: \.self) { index in
//                                                                let item = uploadedImages[index]
//                                                                switch item.media {
//                                                                case .image(let image):
//                                                                    Image(uiImage: image)
//                                                                        .resizable()
//                                                                        .cornerRadius(15)
//                                                                        .frame(width: 150, height: 150)
//                                                                        .overlay(
//                                                                            Button(action: {
//                                                                                removeImage(name: uploadedImages[index].fileName)
//                                                                                uploadedImages.remove(at: index)
//                                                                            }) {
//                                                                                Image(systemName: "xmark.circle.fill")
//                                                                                    .foregroundColor(.red)
//                                                                                    .background(Circle().foregroundColor(.white).frame(width: 30, height: 30))
//                                                                                    .offset(x: 50, y: -50)
//                                                                            }
//                                                                                .buttonStyle(PlainButtonStyle())
//                                                                        )
//                                                                case .video(_):
//                                                                    Image("default_property")
//                                                                        .resizable()
//                                                                        .cornerRadius(15)
//                                                                        .frame(width: 150, height: 150)
//                                                                }
//                                                            }
//                                                        }
//                                                        
//                                                    }
//                                                    .padding(.bottom, 15)
//                                                    if isUploading {
//                                                        ProgressView("Uploading", value: progress, total: 1.0)
//                                                            .progressViewStyle(LinearProgressViewStyle())
//                                                        
//                                                    }
//                                                    
//                                                    Button {
//                                                        hideKeyboard()
//                                                        isOpenImageChooseView = true
//                                                    } label: {
//                                                        HStack {
//                                                            Spacer()
//                                                            Image("camera")
//                                                                .resizable()
//                                                                .foregroundColor(.black)
//                                                                .frame(width: 35, height: 35)
//                                                            Text(LocalizedStringKey("Upload Photos"))
//                                                                .font(.roboto_16_bold())
//                                                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
//                                                                .foregroundColor(Color.black)
//                                                                .padding()
//                                                                .onAppear(){
//                                                                    
//                                                                    if dataHandler.formData[indexVal][index].fieldName.lowercased().contains("motor") {
//                                                                        imageType = "VEHICLE_IMAGES_URL"
//                                                                    } else {
//                                                                        imageType = "PROPERTY_IMAGES_URL"
//                                                                    }
//                                                                    
//                                                                }
//                                                            Spacer()
//                                                        }
//                                                        
//                                                        .background(
//                                                            RoundedRectangle(cornerRadius: 10)
//                                                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
//                                                                .frame( height: 80)
//                                                                .foregroundColor(Color.unselectedBorderColor)
//                                                        )
//                                                    }
//                                                    .disabled(uploadedImages.count >= 10)
//                                                    .sheet(isPresented: .constant(imageSource != .notSelected )) {
//                                                        ImagePickerView(numOfSelectedPictures: uploadedImages.count, images: $uploadedImages, isUploading: $isUploading, fromView: "adpost", typeKey: imageType ,  sourceType: imageSource, chatId: "", pickerType: .constant("image"))
//                                                    }
//                                                    .onChange(of: isUploading) { isUploading in
//                                                        // Reset progress when starting a new upload
//                                                        if isUploading {
//                                                            progress = 0.0
//                                                            hideKeyboard()
//                                                        }
//                                                    }
//                                                    .onChange(of: uploadedImages) { isUploading in
//                                                        isOpenImageChooseView = false
//                                                        imageSource = .notSelected
//                                                        dataHandler.formData[indexVal][index].fieldValue = uploadedImages.map { $0.fileName }.joined(separator: ",")
//                                                    }
//                                                }
//                                            }
//                                            
//                                        case "dropdown":
//                                            if item.fieldName.lowercased().contains("emirates") {
//                                                KulushaeActionFields(placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                                                     fieldType: .dropDown,
//                                                                     imageName: "",
//                                                                     selectedDate: .constant(""),
//                                                                     items: filterDataHandler.statesNameList,
//                                                                     textValue:  item.fieldValue ?? "",
//                                                                     textViewTitle: item.fieldExtras.extra_title ?? "",
//                                                                     isEnableExtraTitle: (((item.fieldExtras.extra_title ?? "") == "" ) ? false : true),
//                                                                     isDatePickerShowing: .constant(false),
//                                                                     index: 0,
//                                                                     didGetValue: { _ , actionValue, _ , _ in
//                                                    hideKeyboard()
//                                                    if let id =  filterDataHandler.statesList.first(where: { $0.name == actionValue  || $0.state_code == actionValue })?.id {
//                                                        selectedStateId = id
//                                                        dataHandler.formData[indexVal][index].fieldValue = actionValue
//                                                    }
//                                                })
//                                                .frame(width : field_size)
//                                                .keyboardType(.default)
//                                                .onTapGesture(){
//                                                    hideKeyboard()
//                                                }
//                                            }
//                                            else if item.fieldName .lowercased().contains("make_id") {
//                                                KulushaeActionFields(placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                                                     fieldType: .dropDown,
//                                                                     imageName: "",
//                                                                     selectedDate: .constant(""),
//                                                                     items: filterDataHandler.motorMakeListName,
//                                                                     textValue:  item.fieldValue ?? "",
//                                                                     textViewTitle: item.fieldExtras.extra_title ?? "",
//                                                                     isEnableExtraTitle: (((item.fieldExtras.extra_title ?? "") == "" ) ? false : true),
//                                                                     isDatePickerShowing: .constant(false),
//                                                                     index: 0,
//                                                                     didGetValue: { _ , actionValue, _ , _ in
//                                                    selectedMAkeId = "-1"
//                                                    hideKeyboard()
//                                                    if let id =  filterDataHandler.motorMakeList.first(where: { $0.title == actionValue })?.id {
//                                                        selectedMAkeId = id
//                                                        filterDataHandler.motorModelList = []
//                                                        filterDataHandler.getMotorModel(makeId: id)
//                                                        dataHandler.formData[indexVal][index].fieldValue = id
//                                                    }
//                                                })
//                                                .frame(width : field_size)
//                                                .keyboardType(.default)
//                                                .onTapGesture(){
//                                                    hideKeyboard()
//                                                }
//                                            } else if item.fieldName.lowercased().contains("model_id") {
//                                                if(selectedMAkeId != "-1") {
//                                                    KulushaeActionFields(placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                                                         fieldType: .dropDown,
//                                                                         imageName: "",
//                                                                         selectedDate: .constant(""),
//                                                                         items:  filterDataHandler.motorModelListName,
//                                                                         textValue:  item.fieldValue ?? "",
//                                                                         textViewTitle: item.fieldExtras.extra_title ?? "",
//                                                                         isEnableExtraTitle: (((item.fieldExtras.extra_title ?? "") == "" ) ? false : true),
//                                                                         isDatePickerShowing: .constant(false),
//                                                                         index: 0,
//                                                                         didGetValue: { _ , actionValue, _ , _ in
//                                                        hideKeyboard()
//                                                        if let id =  filterDataHandler.motorModelList.first(where: { $0.title == actionValue })?.id {
//                                                            dataHandler.formData[indexVal][index].fieldValue = id
//                                                        }
//                                                    })
//                                                    .frame(width : field_size)
//                                                    .keyboardType(.default)
//                                                    .onTapGesture(){
//                                                        hideKeyboard()
//                                                    }
//                                                    
//                                                }
//                                                
//                                            }
//                                            else {
//                                                let options = item.fieldExtras.options ?? [Option(text: "Default Text", value: .stringValue(""))]
//                                                let items = options.map { $0.text }
//                                                KulushaeActionFields(placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                                                     fieldType: .dropDown,
//                                                                     imageName: "",
//                                                                     selectedDate: .constant(""),
//                                                                     items: items,
//                                                                     textValue:  item.fieldValue ?? "",
//                                                                     textViewTitle: item.fieldExtras.extra_title ?? "",
//                                                                     isEnableExtraTitle: (((item.fieldExtras.extra_title ?? "") == "" ) ? false : true),
//                                                                     isDatePickerShowing: .constant(false),
//                                                                     index: 0,
//                                                                     didGetValue: { _ , actionValue, _ , _ in
//                                                    hideKeyboard()
//                                                    var value = ""
//                                                    if let newItem = options.filter({$0.text == actionValue}).first {
//                                                        switch newItem.value {
//                                                        case .intValue(let intValue):
//                                                            value = "\(intValue)"
//                                                            print("Integer Value: \(intValue)")
//                                                        case .doubleValue(let doubleValue):
//                                                            value = "\(doubleValue)"
//                                                            print("Double Value: \(doubleValue)")
//                                                        case .stringValue(let stringValue):
//                                                            value = stringValue
//                                                            print("String Value: \(stringValue)")
//                                                        case .boolValue(let boolValue):
//                                                            value = "\(boolValue)"
//                                                            print("Bool Value: \(boolValue)")
//                                                        }
//                                                    }
//                                                    dataHandler.formData[indexVal][index].fieldValue = value
//                                                })
//                                                .frame(width : field_size)
//                                                .keyboardType(.default)
//                                                .onTapGesture(){
//                                                    hideKeyboard()
//                                                }
//                                            }
//                                            
//                                            ////                                            let items = getDroppedDownItems(usingStringArr: field.masterData ?? [:])
//                                            ////                                            let selectedItem =  ""
//                                            //                                            KulushaeActionFields(placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                            //                                                              fieldType: .dropDown,
//                                            //                                                              imageName: "",
//                                            //                                                              selectedDate: .constant(""),
//                                            //                                                              items: items,
//                                            //                                                              selectedItem: dataHandler.formData[indexVal][index].selectedValue,
//                                            //                                                              textValue: "",
//                                            //                                                              isDatePickerShowing: .constant(false),
//                                            //                                                              index: index,
//                                            //                                                              didGetValue: { _, actionValue, _ , _ in
//                                            //                                                dataHandler.formData[indexVal][index].fieldValue = actionValue
//                                            ////                                                dataHandler.formData[indexVal][index].selectedValue = actionValue
//                                            //                                            })
//                                            
//                                        case "switch":
//                                            HStack {
//                                                Text( (item.fieldExtras.title ?? ""))
//                                                    .foregroundColor(.black)
//                                                Spacer()
//                                                Toggle("" , isOn: $isOn)
//                                                    .toggleStyle(SwitchToggleStyle(tint: Color.iconSelectionColor))
//                                                    .onChange(of: isOn) { newValue in
//                                                        dataHandler.formData[indexVal][index].fieldValue = "\(isOn)"
//                                                    }
//                                            }
//                                        case "button":
//                                            Text("")
//                                                .frame(height: 0.5)
//                                                .onAppear() {
//                                                    if let action = item.fieldExtras.button_action {
//                                                        if(action == "next_step") {
//                                                            if let num = item.fieldExtras.next_step {
//                                                                stepNum = Int(num) ?? -1
//                                                            }
//                                                        } else {
//                                                            stepNum = -1
//                                                        }
//                                                        isNextEnabled = true
//                                                    }
//                                                    action = item.fieldExtras.submit ?? ""
//                                                    dataHandler.formData[indexVal][index].fieldValue = item.fieldExtras.submit ?? ""
//                                                    
//                                                }
//                                        case "date":
//                                            
//                                            KulushaeActionFields(placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                                                 fieldType: .datePickerType,
//                                                                 imageName: "",
//                                                                 selectedDate: $dateString,
//                                                                 items: [],
//                                                                 textValue: "",
//                                                                 textViewTitle:  "",
//                                                                 isEnableExtraTitle: false,
//                                                                 isDatePickerShowing: $isDatePickerShowing,
//                                                                 index: 0,
//                                                                 didGetValue: { _, actionValue, _ , _ in
//                                                hideKeyboard()
//                                            })
//                                            .onChange(of: isDatePickerShowing) { newValue in
//                                                
//                                                if !newValue {
//                                                    print(selectedDate)
//                                                    dateString = selectedDate
//                                                        .toString(withFormat: "yyyy-MM-dd")
//                                                    
//                                                    //                                                    print("dateString", dateString)
//                                                    dataHandler.formData[indexVal][index].fieldValue = dateString
//                                                    
//                                                }
//                                            }
//                                        case "radio":
//                                            KulushaeActionFields(placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                                                 fieldType: .radio,
//                                                                 imageName: "",
//                                                                 selectedDate: .constant(""),
//                                                                 items: [],
//                                                                 textValue: "",
//                                                                 textViewTitle: item.fieldExtras.extra_title ?? "",
//                                                                 radioTitle: item.fieldExtras.options ?? [],
//                                                                 isEnableExtraTitle: (((item.fieldExtras.extra_title ?? "") == "" ) ? false : true),
//                                                                 isDatePickerShowing: .constant(false),
//                                                                 index: 0,
//                                                                 didGetValue: { _, actionValue, _ , _ in
//                                                dataHandler.formData[indexVal][index].fieldValue = actionValue
//                                            })
//                                            .frame(width : field_size)
//                                            .keyboardType(.default)
//                                            
//                                        case "selection_popup":
//                                            VStack {
//                                                KulushaeActionFields(placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                                                     fieldType: .selectionType,
//                                                                     imageName: "",
//                                                                     selectedDate: .constant(""),
//                                                                     items: [],
//                                                                     textValue: "",
//                                                                     textViewTitle: item.fieldExtras.extra_title ?? "",
//                                                                     radioTitle: item.fieldExtras.options ?? [],
//                                                                     isEnableExtraTitle: (((item.fieldExtras.extra_title ?? "") == "" ) ? false : true),
//                                                                     isDatePickerShowing: .constant(false),
//                                                                     index: 0,
//                                                                     didGetValue: { _, actionValue, _ , _ in
//                                                    if let api = item.fieldExtras.api,
//                                                       api.contains("motor") {
//                                                        dataHandler.getMotorList()
//                                                    } else {
//                                                        dataHandler.getAmenityList()
//                                                    }
//                                                    
//                                                })
//                                                .frame(width : field_size)
//                                                .keyboardType(.default)
//                                                ForEach(selectedAmenity.chunked(into: 3), id: \.self) { chunk in
//                                                    HStack(spacing: 10) {
//                                                        ForEach(chunk, id: \.self) { item in
//                                                            HStack {
//                                                                HStack(alignment: .center, spacing: 0) {
//                                                                    Text(LocalizedStringKey(item))
//                                                                        .font(.roboto_14())
//                                                                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
//                                                                        .padding(.leading, 3)
//                                                                        .multilineTextAlignment(.leading)
//                                                                        .foregroundColor(.white)
//                                                                        .padding(.leading, 5)
//                                                                    
//                                                                    Spacer()
//                                                                    ZStack {
//                                                                        Image(uiImage: UIImage(named: "close") ?? UIImage())
//                                                                            .resizable()
//                                                                            .frame(width: 14, height: 14)
//                                                                            .foregroundColor(.white)
//                                                                            .padding(10)
//                                                                    }
//                                                                    .frame(width: 30, height: 30)
//                                                                    .onTapGesture {
//                                                                        if let indexToRemove = selectedAmenity.firstIndex(of: item) {
//                                                                            selectedAmenity.remove(at: indexToRemove)
//                                                                            selectedAmenityIDs.remove(at: indexToRemove)
//                                                                            selectedAmenityIDVal = selectedAmenityIDs.joined(separator: ",")
//                                                                        }
//                                                                    }
//                                                                }
//                                                                .frame(height: 30)
//                                                                .background(Color.iconSelectionColor)
//                                                                .cornerRadius(8)
//                                                                .overlay(
//                                                                    RoundedRectangle(cornerRadius: 8)
//                                                                        .stroke(.clear )
//                                                                )
//                                                            }
//                                                            
//                                                        }
//                                                    }
//                                                    .padding(.horizontal, 15)
//                                                    //                                                    .onChange(of: selectedAmenityIDs) { newValue in
//                                                    //                                                        DispatchQueue.main.async {
//                                                    //                                                            dataHandler.formData[indexVal][index].fieldValue = selectedAmenityIDs.joined(separator: ",")
//                                                    //                                                        }
//                                                    //                                                    }
//                                                }
//                                            }
//                                        case ("map_searchable") :
//                                            VStack{
//                                                //                                                MapSearchTextField(
//                                                //                                                    placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                                //                                                    selectedDate: $selectedPlace,
//                                                //                                                    textValue: self.selectedPlace,
//                                                //                                                    textViewTitle: "",
//                                                //                                                    isEnableExtraTitle: (((item.fieldExtras.extra_title ?? "") == "" ) ? false : true),
//                                                //                                                    didGetValue:  {
//                                                //                                                        _,
//                                                //                                                        actionValue,
//                                                //                                                        _ ,
//                                                //                                                        _ in
//                                                //                                                        print("** wk search value: \(actionValue)")
//                                                //                                                        dataHandler.formData[indexVal][index].fieldValue = self.selectedPlace
//                                                //                                                        searchDelegate.searchAddress(
//                                                //                                                            query: actionValue,
//                                                //                                                            filter: PersistenceManager.shared.countryDataForAddPost?.country.iso2
//                                                //                                                        )
//                                                //                                                    })
//                                                //                                                .frame(width : field_size)
//                                                //                                                .keyboardType(.default)
//                                                //                                                .onTapGesture(){
//                                                //                                                    DispatchQueue.main.async {
//                                                //                                                        isPopoverPresented = true
//                                                //                                                    }
//                                                //                                                }
//                                                MapSearchTextField(
//                                                    placeholder: (item.fieldExtras.title ?? "") + (item.fieldValidation == "optional" ?  optionalKey : "" ),
//                                                    text: $selectedPlace,
//                                                    didGetValue: { actionValue in
//                                                        print("** wk search value: \(actionValue)")
//                                                        dataHandler.formData[indexVal][index].fieldValue = actionValue
//                                                        searchDelegate.searchAddress(
//                                                            query: actionValue,
//                                                            filter: PersistenceManager.shared.countryDataForAddPost?.country.iso2
//                                                        )
//                                                        
//                                                    }
//                                                )
//                                                .frame(width : field_size)
//                                                .keyboardType(.default)
//                                                .onTapGesture(){
//                                                    DispatchQueue.main.async {
//                                                        isPopoverPresented = true
//                                                    }
//                                                }
//                                                if(isPopoverPresented) {
//                                                    ScrollView {
//                                                        VStack {
//                                                            ForEach(searchDelegate.searchResults, id: \.id) { result in
//                                                                Button(action: {
//                                                                    isPopoverPresented = false
//                                                                    selectedPlace =  result.name
//                                                                    let place = result.name + "," + (result.address?.place ?? "")
//                                                                    print("** wk place: \(place)")
//                                                                    
//                                                                    getCoordinates(from: place) { coordinate, error in
//                                                                        if let coordinate = coordinate {
//                                                                            print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
//                                                                            if indexVal < dataHandler.formData.count {
//                                                                                var formData = dataHandler.formData[indexVal]
//                                                                                if index + 1 < formData.count {
//                                                                                    
//                                                                                    dataHandler.formData[indexVal][index + 1].fieldValue = "\(coordinate.latitude),\(coordinate.longitude)"
//                                                                                } else {
//                                                                                    print("Index out of range: \(index + 1) for formData with count \(formData.count)")
//                                                                                }
//                                                                            } else {
//                                                                                print("Index out of range: \(indexVal) for formData with count \(dataHandler.formData.count)")
//                                                                            }
//                                                                            selectedLocation = coordinate
//                                                                            filterDataHandler.selectedLocation = selectedLocation
//                                                                            dataHandler.mapController?.location = selectedLocation
//                                                                            dataHandler.mapController?.updatePinPoint()
//                                                                        } else if let error = error {
//                                                                            print("Error geocoding address: \(error.localizedDescription)")
//                                                                        }
//                                                                    }
//                                                                }) {
//                                                                    VStack {
//                                                                        Text(result.name)
//                                                                            .font(.roboto_14())
//                                                                            .padding()
//                                                                            .foregroundColor(.black)
//                                                                            .frame(height: 35, alignment: .leading)
//                                                                        Divider()
//                                                                            .frame(height: 1)
//                                                                            .padding(.horizontal, 30)
//                                                                            .background(Color.unselectedBorderColor)
//                                                                    }
//                                                                    
//                                                                }
//                                                                .frame(maxHeight: .screenWidth * 0.9)
//                                                            }
//                                                        }
//                                                    }
//                                                    .frame(maxHeight: 200) // Set a maximum height for the ScrollView if needed
//                                                    .background(Color.white)
//                                                    .cornerRadius(8)
//                                                    .shadow(radius: 5)
//                                                    .padding(.top, -10)
//                                                }
//                                                
//                                            }
//                                        case "map":
//                                            ZStack(alignment: .bottomTrailing) {
//                                                MapBoxMapView(selectedLocationCoordinate: $filterDataHandler.selectedLocation, selectedLoca: $selectedPlace) { mapVC in
//                                                    if dataHandler.mapController == nil {
//                                                        dataHandler.mapController = mapVC
//                                                    }
//                                                }
//                                                .frame(height: 400)
//                                                .clipped()
//                                                .cornerRadius(15)
//                                                .onChange(of: filterDataHandler.selectedLocation) { newVal in
//                                                    dataHandler.formData[indexVal][index].fieldValue = "\(newVal.latitude),\(newVal.longitude)"
//                                                }
//                                                .onAppear(){
//                                                    isPopoverPresented = false
//                                                }
//                                                //                                                HStack{
//                                                //                                                    Image("fullscreen")
//                                                //                                                        .onTapGesture {
//                                                //                                                            isFullscreenMap = true
//                                                //                                                        }
//                                                //                                                }
//                                                //                                                .padding(.bottom, 10)
//                                            }
//                                        default:
//                                            Text("")
//                                                .frame(height: 1)
//                                        }
//                                        
//                                        Spacer()
//                                    }
//                                }
//                                
//                            }
//                            
//                        }
//                        .padding(.top, 20)
//                        
//                        
//                    }
//                    .frame(width: .screenWidth * 0.9)
//                    .onTapGesture {
//                        hideKeyboard()
//                    }
//                    Spacer()
//                    if(isNextEnabled ) {
//                        
//                        AppButton(titleVal: stepNum == -1 ? "Publish" : "Next", isSelected: .constant(!((dataHandler.formData.first?.first?.fieldValue ?? "").isEmpty)))
//                            .padding(.horizontal, 25)
//                            .onTapGesture {
//                                dataHandler.isLoading = true
//                                isPopoverPresented = false
//                                processTheFormData()
//                                
//                            }
//                            .frame(height: 40)
//                            .alert(isPresented: .constant(dataHandler.isShowPayment ? paymentDelegate.isPaymentSuccess :  dataHandler.isAddSubmitSuccess)) {
//                                if(paymentDelegate.paymentStatus == .success) {
//                                    Alert(title: Text(LocalizedStringKey("Payment Successfull")), message: Text(LocalizedStringKey(dataHandler.successMessage)),
//                                          dismissButton:
//                                            .destructive(
//                                                Text(LocalizedStringKey("Okay"))
//                                                    .font(.roboto_14())
//                                                    .foregroundColor(.black),
//                                                action: {
//                                                    isHomeOpen = true
//                                                })
//                                    )
//                                }
//                                else if(dataHandler.isAddSubmitSuccess) {
//                                    Alert(title: Text(LocalizedStringKey("Posted Successfully")), message: Text(LocalizedStringKey(dataHandler.successMessage)),
//                                          dismissButton:
//                                            .destructive(
//                                                Text(LocalizedStringKey("Okay"))
//                                                    .font(.roboto_14())
//                                                    .foregroundColor(.black),
//                                                action: {
//                                                    isHomeOpen = true
//                                                })
//                                    )
//                                }
//                                else {
//                                    Alert(title: Text(LocalizedStringKey("Payment Failed")), message: Text(LocalizedStringKey(paymentDelegate.errorMessage)),
//                                          dismissButton:
//                                            .destructive(
//                                                Text(LocalizedStringKey("Okay"))
//                                                    .font(.roboto_14())
//                                                    .foregroundColor(.black),
//                                                action: {
//                                                    
//                                                })
//                                    )
//                                }
//                                
//                            }
//                        
//                    }
//                    
//                }
//                .frame(width: .screenWidth )
//                .padding(.bottom, -25)
//                
//                .dateTimePickerDialog(isShowing: $isDatePickerShowing,
//                                      cancelOnTapOutside: true,
//                                      selection: $selectedDate,
//                                      displayComponents: [.date],
//                                      style: .graphical,
//                                      buttons: [
//                                        .default(label:"Ok"),
//                                        .cancel(label: "Cancel")
//                                        
//                                      ]) {
//                                          Text(LocalizedStringKey("Ready By"))
//                                              .font(.roboto_14())
//                                          
//                                      }
//                                      .padding(.horizontal, 25)
//                
//                if showErrorPopup {
//                    TopStatusToastView(message: errMessage,
//                                       type: .error) {
//                        showErrorPopup = false
//                    }
//                }
//                
//                if(!dataHandler.errorMessage.isEmpty) {
//                    TopStatusToastView(message: dataHandler.errorMessage,
//                                       type: .error) {
//                        dataHandler.errorMessage = ""
//                    }
//                }
//                BottomSheetView(isOpen: $isOpenImageChooseView,
//                                maxHeight: 250) {
//                    ImageChooseView(selectedPicType: $imageSource, isOpen: $isOpenImageChooseView)
//                    
//                }.edgesIgnoringSafeArea(.all)
//                    .frame(width: .screenWidth,
//                           height: isOpenImageChooseView ? .screenHeight  : 0.0,
//                           alignment: .bottom)
//                    .opacity(isOpenImageChooseView ? 1.0 : 0.0)
//                
//                BottomSheetView(isOpen: $dataHandler.isAmenityChosen,
//                                maxHeight: 500) {
//                    SelectionPopupView(isOpen:  $dataHandler.isAmenityChosen, popupData: $dataHandler.amenityData, selectedArray: $selectedAmenity, selectedAmenityId: $selectedAmenityIDs, valueAmenity: $selectedAmenityIDVal)
//                    
//                }.edgesIgnoringSafeArea(.all)
//                    .frame(width: .screenWidth,
//                           height:  dataHandler.isAmenityChosen ? .screenHeight  : 0.0,
//                           alignment: .bottom)
//                    .opacity( dataHandler.isAmenityChosen ? 1.0 : 0.0)
//                
//                if  dataHandler.isShowPayment &&  paymentDelegate.paymentStatus == .none {
//                    let paymentConfiguration = PaymentSDKConfiguration(profileID: Config.payTabProfileID,
//                                                                       serverKey: Config.payTabServerKey,
//                                                                       clientKey: Config.payTabClientKey,
//                                                                       currency: dataHandler.paymentResult?.currency_code ?? "" ,
//                                                                       amount: Double(dataHandler.paymentResult?.amount ?? "0.0") ?? 0.0,
//                                                                       merchantCountryCode: dataHandler.paymentResult?.country_code ?? "")
//                        .cartID(dataHandler.paymentResult?.cart_id ?? "" )
//                        .cartDescription(dataHandler.paymentResult?.cart_description ?? "")
//                        .languageCode("en")
//                    
//                    PaymentView(configuration: paymentConfiguration, delegate: paymentDelegate)
//                }
//            }
//            
//        }
//        .onAppear() {
//            print("current lang is", languageManager.currentLanguage)
//            //            searchEngine.delegate = searchDelegate
//            SearchEngineSingleton.shared.delegate = searchDelegate
//            
//            if(!openedStates.contains(stepNum) && !self.fromPayment) {
//                print("fetching id", AdDetailsView.parentCatIdVal)
//                dataHandler.fetchDataList(request: AdDetailsViewModel.MakeGetFormRequest.Request(catId: AdDetailsView.parentCatIdVal, steps: stepNum))
//                openedStates.append(stepNum)
//            }
//            filterDataHandler.getMotorMake()
//            filterDataHandler.getStates()
//            selectedLocation = filterDataHandler.selectedLocation
//        }
//        .onDisappear {
//            // Executed when the view disappears (navigating back)
//            //for testing cicd
//            if(!self.fromPayment){
//                stepNum = stepNum - 1
//            }
//            
//        }
//        
//        
//        NavigationLink("", destination: AdDetailsView(newCatIdVal: newCatIdVal, titleVal: titleVal, stepNum: stepNum, isNextEnabled: false),
//                       isActive: $isOpenNextScreen)
//        NavigationLink("", destination: MainView(),
//                       isActive: $isHomeOpen)
//        NavigationLink("", destination: MapDetailsView(isFullscreen: $isFullscreenMap, selectedLocation: $selectedLocation, selectedPlace: $selectedPlace),
//                       isActive: $isFullscreenMap)
//        .navigationBarBackButtonHidden(true)
//    }
//    
//    func loadImage() {
//        // Handle the selected image here, e.g., save it to a variable or upload it
//        hideKeyboard()
//    }
//    
//    private func hideKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//    
//    func searchAddress() {
//        let options = SearchOptions(countries: ["AE", "BH", "EG", "IQ", "KW", "LB","OM","QA", "SA"])
//        searchDelegate.searchAddress(query: searchQuery)
//    }
//    
//    func processTheFormData()  {
//        for formData in dataHandler.formData {
//            for formItem in formData {
//                // Extract the relevant fields from FetchFormDataModel
//                let fieldName = formItem.fieldName
//                let fieldValue = formItem.fieldValue
//                
//                
//                // Check if fieldValue is not nil
//                let fieldValues = fieldValue ?? ""
//                var fieldDictionary: [String: Any]  = [:]
//                if((fieldName == "amenities" || fieldName.contains("extras")) && !selectedAmenityIDVal.isEmpty) {
//                    //                    print("amenity value...", selectedAmenityIDVal)
//                    fieldDictionary = ["fieldName": fieldName, "fieldValue": selectedAmenityIDVal]
//                }
//                else if(fieldName == "images" && !uploadedImages.isEmpty ) {
//                    
//                    fieldDictionary = ["fieldName": fieldName, "fieldValue": uploadedImages.map { $0.fileName }.joined(separator: ",")]
//                }
//                else {
//                    if(!fieldValues.isEmpty) {
//                        fieldDictionary = ["fieldName": fieldName, "fieldValue": fieldValues]
//                    }
//                }
//                // Append the dictionary to the array
//                AdDetailsView.fieldValueArray.append(fieldDictionary)
//            }
//        }
//        
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//        let (msg, hasBeenValidated) = isValidated(request: dataHandler.formData)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            errMessage = msg
//            showErrorPopup = !hasBeenValidated
//            if !showErrorPopup   {
//                if( stepNum != -1) {
//                    isOpenNextScreen = true
//                    dataHandler.isLoading = false
//                } else {
//                    submitRequest()
//                    //                    model.preparePaymentSheet(catId: newCatIdVal)
//                    //                                        if let viewController = UIApplication.shared.windows.first?.rootViewController {
//                    //                                            model.presentPaymentSheet(from: viewController)
//                    //                                        }
//                }
//                
//            } else {
//                dataHandler.isLoading = false
//            }
//        }
//        
//    }
//    
//    func isValidated(request: [[FetchFormDataModel]]) -> (String ,Bool) {
//        let requiredText = languageManager.currentLanguage == "ar" ? "مطلوب": "Is required"
//        for fields in  request {
//            for field in fields {
//                let isRequired = field.fieldValidation
//                
//                //                if(field.fieldType == "phone") {
//                //                    if (!(field.fieldValue ?? "").isValidPhone()) {
//                //                        return ("Phone number is not valid", false )
//                //                    }
//                //                }
//                if((field.fieldName == "amenities" || field.fieldName.contains("extras")) &&  (isRequired == "required")) {
//                    if(selectedAmenityIDVal.isEmpty) {
//                        return(((field.fieldExtras.title ?? field.fieldName) + " " + requiredText), false)
//                    }
//                } else {
//                    
//                    let value = field.fieldValue ?? ""
//                    let name = field.fieldExtras.title ?? field.fieldName
//                    
//                    if(isRequired == "required" && value.isEmpty) {
//                        return((name + " " + requiredText ), false)
//                    }
//                }
//            }
//        }
//        return ("", true)
//    }
//    
//    func submitRequest() {
//        var argsDictionary: [String: Any?] = [:]
//        let fieldDictionary: [String: Any] = ["fieldName": "category_id", "fieldValue": "\(newCatIdVal)"]
//        //        argsDictionary["country_id"] = "\(UserDefaultManager.get(.choseCityId) ?? -1)"
//        argsDictionary["country_id"] = "\(PersistenceManager.shared.countryDataForAddPost?.country.id ?? -1)"
//        argsDictionary["currency"] = "\(UserDefaultManager.get(.chosenCurrency) ?? "AED")"
//        argsDictionary["state_id"] = "\(selectedStateId)"
//        if let state = PersistenceManager.shared.countryDataForAddPost?.selectedStateID {
//            argsDictionary["emirates"] = "\(state)"
//        }
//        
//        // Append the dictionary to the array
//        AdDetailsView.fieldValueArray.append(fieldDictionary)
//        
//        for fieldItem in AdDetailsView.fieldValueArray {
//            // Extract fieldName and fieldValue from the dictionary
//            if let fieldName = fieldItem["fieldName"] as? String, let fieldValue = fieldItem["fieldValue"] {
//                // Add fieldName and fieldValue to the argsDictionary
//                argsDictionary[fieldName] = fieldValue
//            }
//        }
//        fromPayment = true
//        paymentDelegate.paymentStatus = .none
//        paymentDelegate.productType =  self.action.contains("motor") ? "motors" : "property"
//        if(self.action.contains("motor")) {
//            dataHandler.carSubmission(request: argsDictionary)
//        } else {
//            dataHandler.advSubmission(request: argsDictionary)
//        }
//    }
//    
//    func removeImage(name:String) {
//        let urlString = Config.baseURL + Config.imageDelateUrl
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(UserDefaults.standard.string(forKey: Keys.Persistance.authKey.rawValue) ?? "")", forHTTPHeaderField: "Authorization")
//        
//        let parameters: [String: Any] = [
//            "key": name,
//            "type": self.imageType
//        ]
//        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//        } catch {
//            print("Error encoding JSON: \(error)")
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                // Handle the error (e.g., show an alert to the user)
//                return
//            }
//            
//            guard let data = data else {
//                print("No data received from the server")
//                // Handle the absence of data (e.g., show an alert to the user)
//                return
//            }
//            
//            // Handle the response data here
//            do {
//                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//                print("Response: \(jsonResponse)")
//                // Process the response as needed
//            } catch {
//                print("Error parsing JSON: \(error)")
//                // Handle the error (e.g., show an alert to the user)
//            }
//        }
//        
//        task.resume()
//        hideKeyboard()
//    }
//    
//}
//
//struct CustomDropdownMenu: View {
//    let placeholder: String
//    let items: [String]
//    @Binding var selectedOption: String
//    var didGetValue: (Int, String) -> Void
//    @EnvironmentObject var languageManager: LanguageManager
//    @State private var isMenuVisible = false
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 1) {
//            // Placeholder
//            Text(LocalizedStringKey(placeholder))
//                .font(.roboto_14())
//                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
//                .foregroundColor(Color.black)
//                .scaleEffect(selectedOption.isEmpty ? 1.0 : 0.8, anchor: .leading)
//                .padding(.horizontal, selectedOption.isEmpty ? 0 : 8)
//                .background(Color.white)
//                .offset(y: selectedOption.isEmpty ? 0 : -15)
//                .onTapGesture {
//                    withAnimation {
//                        isMenuVisible.toggle()
//                    }
//                }
//            
//            // Dropdown Menu
//            if isMenuVisible {
//                ForEach(items, id: \.self) { item in
//                    Button(action: {
//                        selectedOption = item
//                        didGetValue(0, item)
//                        withAnimation {
//                            isMenuVisible.toggle()
//                        }
//                    }) {
//                        Text(LocalizedStringKey(item))
//                            .font(.roboto_14())
//                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
//                    }
//                    .foregroundColor(.black)
//                    .padding(.horizontal)
//                }
//                .background(Color.white)
//                .border(Color.black)
//                .cornerRadius(5)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 5)
//                        .stroke(Color.black, lineWidth: 1)
//                )
//            }
//        }
//        .frame(height: 40, alignment: .center)
//        .font(.body)
//        .disableAutocorrection(true)
//        .textInputAutocapitalization(.none)
//    }
//}
//
//fileprivate func getCoordinates(from address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
//    let geocoder = CLGeocoder()
//    
//    geocoder.geocodeAddressString(address) { placemarks, error in
//        if let error = error {
//            // Handle error (e.g., address not found, network issues, etc.)
//            completion(nil, error)
//            return
//        }
//        
//        if let placemarks = placemarks, let location = placemarks.first?.location {
//            // Successfully found the coordinates
//            completion(location.coordinate, nil)
//        } else {
//            // No placemarks found for the address
//            completion(nil, NSError(domain: "GeocodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Address not found"]))
//        }
//    }
//}
