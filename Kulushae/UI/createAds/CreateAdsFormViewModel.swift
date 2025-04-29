//
//  CreateAdsFormViewModel.swift
//  Kulushae
//
//  Created by Waseem  on 21/01/2025.
//

import Foundation
import Apollo
import StripePaymentSheet
import UIKit
import CoreLocation
import PhoneNumberKit

enum ServiceType: String {
    case None = ""
    case Motor = "motors"
    case Property = "property"
}

enum ImageSource {
    case gallery
    case camera
    case notSelected
}

struct MediaModel: Equatable {
    enum MediaType {
        case image(UIImage)
        case video(URL)
    }
    
    var media: MediaType
    var fileName: String
    var url: String?
    var id: String = ""
    var isUploaded: Bool
    
    init(image: UIImage, fileName: String, url: String? = nil, id: String = "", isUploaded: Bool = false) {
        self.media = .image(image)
        self.fileName = fileName
        self.url = url
        self.id = id
        self.isUploaded = isUploaded
    }
    
    init(videoURL: URL, fileName: String, url: String? = nil, id: String = "", isUploaded: Bool = false) {
        self.media = .video(videoURL)
        self.fileName = fileName
        self.url = url
        self.id = id
        self.isUploaded = isUploaded
    }
    
    static func == (lhs: MediaModel, rhs: MediaModel) -> Bool {
        switch (lhs.media, rhs.media) {
        case (.image(let lhsImage), .image(let rhsImage)):
            return lhsImage == rhsImage && lhs.fileName == rhs.fileName && lhs.url == rhs.url && lhs.isUploaded == rhs.isUploaded && lhs.id == rhs.id
        case (.video(let lhsURL), .video(let rhsURL)):
            return lhsURL == rhsURL && lhs.fileName == rhs.fileName && lhs.url == rhs.url && lhs.isUploaded == rhs.isUploaded && lhs.id == rhs.id
        default:
            return false
        }
    }
}

enum PostAdsOptions: String {
    case Text = "text"
    case Phone = "phone"
    case Price = "price"
    case TextView = "textview"
    case Float = "float"
    case File = "file"
    case DropDown = "dropdown"
    case Switch = "switch"
    case Button = "button"
    case Date = "date"
    case Radio = "radio"
    case SelectionPopup = "selection_popup"
    case MapSearchable = "map_searchable"
    case Map = "map"
}

enum CreateAdsFormViewModel {
    
    // MARK: Use cases
    
    enum MakeGetFormRequest {
        struct Request: Codable {
            var catId: Int
            var steps: Int?
        }
        
        struct Response: Codable {
            var formData: [FetchFormDataModel]
        }
    }
    
    enum MakeGetAmenitiesRequest {
        struct Response: Codable {
            var amenityData: [AmenityList]
        }
    }
    
    enum MakeAdSubmit{
        struct Response: Codable {
            var response: SubmitResponseModel?
        }
    }
    
    enum UpdateMotorSubmit{
        struct Response: Codable {
            var response: UpdateMotorFormResponseModel?
        }
    }
    
    enum UpdatePropertySubmit{
        struct Response: Codable {
            var response: UpdatePropertyFormResponseModel?
        }
    }
    
    class ViewModel: ObservableObject {
        
        private static let apiHandler = CreateAdsPostWebService()
        private let propertyApiHandler = ProductDetailsWebService()
        private let postedCarApiHandler = CarDetailsWebService()
        private let filterApiHandler = MotorFilterWebServices()
        
        @Published var amenityData: [AmenityList] = []
        @Published var formData: [[FetchFormDataModel]] = []
        @Published var isLoading: Bool = false
        @Published var isAmenityChosen = false
        @Published var errorMessage: String = ""
        @Published var successMessage: String = ""
        @Published var isAddSubmitSuccess: Bool = false
        @Published var paymentResult: PaymentModel?
        @Published var isShowPayment: Bool = false
        @Published var openedStates: [Int] = []
        @Published var fromPayment: Bool = false
        @Published var newCatIdVal: Int
        @Published var imageSource: ImageSource = .notSelected
        @Published var uploadedImages: [MediaModel] = []
//        @Published var isOn = false
        @Published var stepNum: Int
        @Published var isOpenNextScreen = false
        @Published var isOpenPaymentScreen = false
        @Published var isNextEnabled = false
        @Published var dateString: String = ""
        @Published var isDatePickerShowing: Bool = false
        @Published var selectedDate: Date = Date()
        @Published var selectedAmenity:[String]  = []
        @Published var selectedAmenityIDs:[String]  = []
        @Published var selectedAmenityIDVal: String   = ""
        @Published var isPopoverPresented: Bool = false
        @Published var searchQuery: String = ""
        @Published var selectedPlace: String = ""
        @Published var selectedLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
        @Published var showErrorPopup: Bool = false
        @Published var errMessage: String = ""
        @Published var progress: Double = 0.0
        @Published var isUploading = false
        @Published var isOpenImageChooseView: Bool = false
        @Published var selectedOption : String = ""
        @Published var action: String = ""
        @Published var imageType = "PROPERTY_IMAGES_URL"
        @Published var isHomeOpen: Bool = false
        @Published var selectedMAkeId: String = "-1"
        @Published var selectedStateId: Int = -1
        @Published var isFullscreenMap: Bool = false
        @Published var phoneCountry = "AE"
        @Published var phoneNumber = "+971"
        
        //        @Published var filterDataHandler = MotorFilterViewModel.ViewModel()
        
        @Published var motorMakeList: [MotorMake] = []
        @Published var motorMakeListName: [String] = []
        @Published var motorModelList: [MotorModel] = []
        @Published var motorModelListName: [String] = []
        @Published var statesList: StatesModel = []
        @Published var statesNameList: [String] = []
        
        var mapController: MapViewController? = nil
        var title = ""
        var fieldValueArray: [[String: Any]] = []
        var parentCatIdVal = -1
        
        var advData: AdvModel? = nil
        var propertyData: PropertyData? = nil
        var motorData: PostedCars? = nil
        var serviceType: ServiceType = .None
        var isEditForm: Bool {
            advData != nil
        }
        
        init(title: String, newCatIdVal: Int, stepNum: Int, parentCatIdVal: Int = -1, advData: AdvModel? = nil, serviceType: ServiceType, previosFormData: [[String: Any]] = []) {
            self.title = title
            self.newCatIdVal = newCatIdVal
            self.stepNum = stepNum
            self.parentCatIdVal = parentCatIdVal
            self.advData = advData
            self.serviceType = serviceType
            
            fieldValueArray = previosFormData
            
            
            if serviceType == .Motor {
                getMotorMake()
                getStates()
            } else if serviceType == .Property {
                
            }
            
            if let advData {
                getAmenityList(isFromFilter: true)
//                self.serviceType = ServiceType(rawValue: trim(advData.type)) ?? .None
                if serviceType == .Motor {
                    getMotorDetails(request: CarDetailsViewModel.GetCarDetailsRequest.Request(carId: advData.id ?? 0))
                } else if serviceType == .Property {
                    getPropertyAdvDetail(request: ProductDetailsViewModel.GetProductDetailsRequest.Request(propertyId: advData.id ?? 0))
                }
            } else {
                fetchDataList(request: CreateAdsFormViewModel.MakeGetFormRequest.Request(catId: newCatIdVal, steps: stepNum))
            }
        }
        
        func configEditFormForMotor() {
            guard let motor = motorData else { return }
            
            if let advData {
                var newForm = formData
                formData.enumerated().forEach { indexVal, singleForm in
                    singleForm.enumerated().forEach({ index, form in
                        let fieldName = form.fieldName
                        let fieldType = form.fieldType
                        
                        if fieldType == "dropdown" {
                            if fieldName == "make_id" {
                                if let first = motorMakeList.filter({$0.id == trim(motor.makeId)}).first {
                                    newForm[indexVal][index].fieldEditedValue = trim(first.title)
                                }
                                newForm[indexVal][index].fieldValue = trim(motor.makeId)
                            } else if fieldName == "model_id" {
                                if let first = motorModelList.filter({$0.id == trim(motor.modelId)}).first {
                                    newForm[indexVal][index].fieldEditedValue = trim(first.title)
                                }
                                newForm[indexVal][index].fieldValue = trim(motor.modelId)
                            } else if fieldName == "body_type" {
                                let value = trim(motor.bodyType)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            } else if fieldName == "trim" {
                                let value = trim(motor.trim)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            } else if fieldName == "specs" {
                                let value = trim(motor.specs)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            } else if fieldName == "fuel_type" {
                                let value = trim(motor.fuelType)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            } else if fieldName == "horsepwer" {
                                let value = trim(motor.horsepwer)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            } else if fieldName == "steering_side" {
                                let value = trim(motor.steeringSide)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            } else if fieldName == "engine_capacity" {
                                let value = trim(motor.engineCapacity)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            } else if fieldName == "interior_color" {
                                let value = trim(motor.interiorColor)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            } else if fieldName == "exterior_color" {
                                let value = trim(motor.exteriorColor)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            } else if fieldName == "doors" {
                                let value = trim(motor.doors)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            } else if fieldName == "no_of_cylinders" {
                                let value = trim(motor.noOfCylinders)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            } else if fieldName == "transmission_type" {
                                let value = trim(motor.transmissionType)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            } else if fieldName == "seating_capacity" {
                                let value = trim(motor.seatingCapacity)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            }
                        } else if fieldType == "radio" {
                            if fieldName == "insured_in_uae" {
                                newForm[indexVal][index].fieldValue = (motor.insuredInUae ?? false) ? "1" : "0"
                            } else if fieldName == "is_new" {
                                newForm[indexVal][index].fieldValue = (motor.isNew ?? false) ? "1" : "0"
                            } else if fieldName == "seller" {
                                newForm[indexVal][index].fieldValue = trim(motor.seller?.lowercased())
                            }
                        } else {
                            if fieldName == "year" {
                                newForm[indexVal][index].fieldValue = trim(motor.year)
                            } else if fieldName == "kilometers" {
                                newForm[indexVal][index].fieldValue = trim(motor.kilometers)
                            } else if fieldName == "price" {
                                newForm[indexVal][index].fieldValue = trim(motor.price)
                            } else if fieldName == "contact_info" {
                                
                                newForm[indexVal][index].fieldValue = trim(motor.contactInfo)
                                self.phoneNumber = trim(motor.contactInfo)
                                
                                let phoneNumberKit = PhoneNumberKit()
                                do {
                                    let phoneNumber = try phoneNumberKit.parse("+\(trim(motor.contactInfo))")
                                    
                                    if let region = try? phoneNumberKit.parse("+\(trim(motor.contactInfo))").regionID {
                                        phoneCountry = region
                                        self.phoneNumber = phoneNumber.numberString
                                    }
                                } catch {
                                    print("Error parsing phone number: \(error)")
                                }
                            } else if fieldName == "title" {
                                newForm[indexVal][index].fieldValue = trim(motor.title)
                            } else if fieldName == "desc" {
                                newForm[indexVal][index].fieldValue = trim(motor.desc)
                            } else if fieldName == "tour_url" {
                                newForm[indexVal][index].fieldValue = trim(motor.tourURL)
                            } else if fieldName == "images" {
                                let images = motor.images ?? []
                                uploadedImages = images.map({ MediaModel(image: UIImage(), fileName: trim($0.image), id: trim($0.id), isUploaded: true)})
                            } else if fieldName == "extras" {
                                selectedAmenity = (motor.extras ?? []).map({$0.title}).compactMap({$0})
                                selectedAmenityIDs = (motor.extras ?? []).map({$0.id}).compactMap({$0})
                                selectedAmenityIDVal = selectedAmenityIDs.joined(separator: ", ")
                            }
//                            else if fieldName == "map" {
//                                let value = trim(motor.location)
//                                let coordinates = value.split(separator: ",").map({ Double($0) ?? 0.0})
//                                if coordinates.count == 2 {
//                                    selectedLocation = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates1)
//                                }
//                                newForm[indexVal][index].fieldValue = value
//                            }
                        }
                    })
                }
                
                formData = newForm
            }
        }
        
        func configEditFormForProperty() {
            guard let property = propertyData else { return }
            
            if let advData {
                var newForm = formData
                formData.enumerated().forEach { indexVal, singleForm in
                    singleForm.enumerated().forEach({ index, form in
                        let fieldName = form.fieldName
                        let fieldType = form.fieldType
                        
                        if fieldType == "dropdown" {
                            if fieldName == "bedrooms" {
                                let value = trim(property.bedrooms)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                                print("** wk bed: \(newForm[indexVal][index].fieldValue)")
                                print("** wk bed: \(newForm[indexVal][index].fieldEditedValue)")
                            } else if fieldName == "bathrooms" {
                                let value = trim(property.bathrooms)
                                newForm[indexVal][index].fieldValue = checkDropDownOptionCurrentValue(form.fieldExtras.options ?? [], value: value)
                                newForm[indexVal][index].fieldEditedValue = value
                            }
                        } else {
                            if fieldName == "title" {
                                newForm[indexVal][index].fieldValue = trim(property.title)
                            } else if fieldName == "contact_number" {
                                newForm[indexVal][index].fieldValue = trim(property.contactNumber)
                                self.phoneNumber = trim(property.contactNumber)
                                
                                let phoneNumberKit = PhoneNumberKit()
                                do {
                                    let phoneNumber = try phoneNumberKit.parse("+\(trim(property.contactNumber))")
                                    
                                    if let region = try? phoneNumberKit.parse("+\(trim(property.contactNumber))").regionID {
                                        phoneCountry = region
                                        self.phoneNumber = phoneNumber.numberString
                                    }
                                } catch {
                                    print("Error parsing phone number: \(error)")
                                }
                            } else if fieldName == "price" {
                                newForm[indexVal][index].fieldValue = trim(property.price)
                            } else if fieldName == "description" {
                                newForm[indexVal][index].fieldValue = trim(property.description_val)
                            } else if fieldName == "images" {
                                let images = property.images ?? []
                                uploadedImages = images.map({ MediaModel(image: UIImage(), fileName: trim($0.image), id: trim($0.id), isUploaded: true)})
                            } else if fieldName == "url_360" {
                                let socials = property.socialmedia ?? []
                                if let first = socials.filter({trim($0.type) == "url_360"}).first {
                                    newForm[indexVal][index].fieldValue = trim(first.value)
                                }
                            } else if fieldName == "youtube_url" {
                                let socials = property.socialmedia ?? []
                                if let first = socials.filter({trim($0.type) == "youtube_url"}).first {
                                    newForm[indexVal][index].fieldValue = trim(first.value)
                                }
                            } else if fieldName == "deposit" {
                                newForm[indexVal][index].fieldValue = trim(property.deposit)
                            } else if fieldName == "reference_number" {
                                newForm[indexVal][index].fieldValue = trim(property.referenceNumber)
                            } else if fieldName == "amenities" {
                                selectedAmenity = (property.amenities ?? []).map({$0.title}).compactMap({$0})
                                selectedAmenityIDs = (property.amenities ?? []).map({$0.id}).compactMap({$0})
                                selectedAmenityIDVal = selectedAmenityIDs.joined(separator: ", ")
                            } else if fieldName == "neighbourhood" {
                                let value = trim(property.neighbourhood)
                                selectedPlace = value
                                newForm[indexVal][index].fieldValue = value
                                print("** wk parsed date: \(formData[indexVal][index].fieldValue)")
                            } else if fieldName == "size" {
                                newForm[indexVal][index].fieldValue = trim(property.size)
                            } else if fieldName == "developer" {
                                newForm[indexVal][index].fieldValue = trim(property.developer)
                            } else if fieldName == "ready_by" {

                                let timestamp: Double = (Double(trim(property.readyBy)) ?? 0.0) / 1000.0 // Convert from milliseconds to seconds
                                let date = Date(timeIntervalSince1970: timestamp)
                                print("** wk parsed date: \(date)")
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"  // Use custom date format

                                let formattedDate = dateFormatter.string(from: date)
                                print("** wk parsed date1: \(formattedDate)")
                                selectedDate = date
                                newForm[indexVal][index].fieldValue = formattedDate
                            } else if fieldName == "annual_community_fee" {
                                newForm[indexVal][index].fieldValue = trim(property.anualCommunityFee)
                            } else if fieldName == "furnished" {
                                newForm[indexVal][index].fieldValue = trim(property.furnished)
                            } else if fieldName == "total_closing_fee" {
                                newForm[indexVal][index].fieldValue = trim(property.totalClosingFee)
                            } else if fieldName == "buyer_transfer_fee" {
                                newForm[indexVal][index].fieldValue = trim(property.buyerTransferFee)
                            } else if fieldName == "seller_transfer_fee" {
                                newForm[indexVal][index].fieldValue = trim(property.sellerTransferFee)
                            } else if fieldName == "maintenance_fee" {
                                newForm[indexVal][index].fieldValue = trim(property.maintenanceFee)
                            } else if fieldName == "occupancy_status" {
                                let value = trim(property.occupancyStatus)
                                newForm[indexVal][index].fieldValue = value
//                                if ["1", "true"].contains(value) {
//                                    newForm[indexVal][index].fieldValue = "true"
//                                } else {
//                                    newForm[indexVal][index].fieldValue = "false"
//                                }
                            } else if fieldName == "posted_by" {
                                let value = trim(property.postedBy)
                                newForm[indexVal][index].fieldValue = value
                            } else if fieldName == "location" {
                                let value = trim(property.location)
                                let coordinates = value.split(separator: ",").map({ Double($0) ?? 0.0})
                                if coordinates.count == 2 {
                                    selectedLocation = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
                                    
                                    self.mapController?.location = self.selectedLocation
                                    self.mapController?.updatePinPoint()
                                }
                                newForm[indexVal][index].fieldValue = value
                                print("** wk location: \(newForm[indexVal][index].fieldValue)")
                            }
                        }
                        print("** wk name: \(form.fieldName), value: \(form.fieldValue) ==== name: \(newForm[indexVal][index].fieldName), value: \(newForm[indexVal][index].fieldValue)")
                    })
                }
                
                formData = newForm
            }
        }
        
        func checkDropDownOptionCurrentValue(_ options: [Option], value: String) -> String {
            var currentValue = ""
            if let first = options.filter({$0.text == value}).first {
                var valueAsString: String
                
                switch first.value {
                case .intValue(let intValue):
                    valueAsString = String(intValue)
                case .doubleValue(let doubleValue):
                    valueAsString = String(doubleValue)
                case .stringValue(let stringValue):
                    valueAsString = stringValue
                case .boolValue(let boolValue):
                    valueAsString = String(boolValue)
                }
                
                currentValue = valueAsString
            }
            //            options.forEach{ option in
            //                var valueAsString: String
            //
            //                switch option.value {
            //                case .intValue(let intValue):
            //                    valueAsString = String(intValue)
            //                case .doubleValue(let doubleValue):
            //                    valueAsString = String(doubleValue)
            //                case .stringValue(let stringValue):
            //                    valueAsString = stringValue
            //                case .boolValue(let boolValue):
            //                    valueAsString = String(boolValue)
            //                }
            //                if valueAsString == value {
            //                    currentValue = option.text
            //                }
            //            }
            return currentValue
            
            
        }
        func checkSelectedRadioOptionValue(_ options: [Option], _ value: String) -> String {
            var text = ""
            //            if let first = options.filter({$0.text == value}).first {
            //                var valueAsString: String
            //
            //                switch first.value {
            //                case .intValue(let intValue):
            //                    valueAsString = String(intValue)
            //                case .doubleValue(let doubleValue):
            //                    valueAsString = String(doubleValue)
            //                case .stringValue(let stringValue):
            //                    valueAsString = stringValue
            //                case .boolValue(let boolValue):
            //                    valueAsString = String(boolValue)
            //                }
            //
            //                text = valueAsString
            //            }
            options.forEach{ option in
                var valueAsString: String
                
                switch option.value {
                case .intValue(let intValue):
                    valueAsString = String(intValue)
                case .doubleValue(let doubleValue):
                    valueAsString = String(doubleValue)
                case .stringValue(let stringValue):
                    valueAsString = stringValue
                case .boolValue(let boolValue):
                    valueAsString = String(boolValue)
                }
                if valueAsString == value {
                    text = option.text
                }
            }
            return text
        }
        
        
        // call to network functions
        func fetchDataList(request: CreateAdsFormViewModel.MakeGetFormRequest.Request) {
            self.isLoading = true
            
            ViewModel.apiHandler.fetchFormDataList(catId: request.catId, steps: request.steps) { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                if let formResponse = response {
                    self.formData = formResponse
                    
                    if self.serviceType == .Motor {
                        configEditFormForMotor()
                    } else if self.serviceType == .Property {
                        configEditFormForProperty()
                    }
                }
            }
        }
        
        func getAmenityList(isFromFilter: Bool = false) {
            self.isLoading = true
            self.amenityData = []
            ViewModel.apiHandler.fetchAmenityDataList { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                if let amenityData = response {
                    self.amenityData = amenityData
                    if((amenityData.count > 0) && (!isFromFilter)) {
                        isAmenityChosen = true
                    } else {
                        isAmenityChosen = false
                    }
                }
            }
        }
        
        func getMotorList(isFromFilter: Bool = false) {
            self.isLoading = true
            self.amenityData = []
            ViewModel.apiHandler.fetchMotorDataList { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                if let amenityData = response {
                    self.amenityData = amenityData
                    if((amenityData.count > 0) && (!isFromFilter)) {
                        isAmenityChosen = true
                    } else {
                        isAmenityChosen = false
                    }
                }
            }
        }
        
        func advSubmission(request: [String: Any?]) {
            
            if let form = advData, let formId = form.id {
                updatePropertyAdv(formId: formId, request: request)
            } else {
                addPropertyAdv(request: request)
            }
        }
        
        func addPropertyAdv(request: [String: Any?]) {
            self.isLoading = true
            ViewModel.apiHandler.submitAdvertisement(request: request) { [weak self]  response in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = response.response?.errors?.first?.errorFields?.first?.value ??  response.response?.errors?.first?.message ?? ""
                self.successMessage = response.response?.data?.storeProperty?.message ?? ""
                if let payment = response.response?.data?.storeProperty?.payment,
                   let customer = response.response?.data?.storeProperty?.payment?.cart_id,
                   customer != "" {
                    paymentResult = payment
                    self.isShowPayment = true
                } else {
                    if let success = response.response?.data?.storeProperty?.status  {
                        self.isAddSubmitSuccess = (success == "success")
                    }
                }
            }
        }
        
        func updatePropertyAdv(formId: Int, request: [String: Any?]) {
            self.isLoading = true
            ViewModel.apiHandler.updatePropertyAdvApi(formId: formId, request: request) { [weak self]  response in
                guard let self = self else { return }
                self.isLoading = false
                if let success = response.response?.status {
                    self.isAddSubmitSuccess = (success == "success")
                }
            }
        }
        
        func carSubmission(request: [String: Any?]) {
            if let form = advData, let formId = form.id {
                updateCarSubmit(formId: formId, request: request)
            } else {
                addCarSubmit(request: request)
            }
        }
        
        func addCarSubmit(request: [String: Any?]) {
            self.isLoading = true
            ViewModel.apiHandler.submitCars(request: request) { [weak self]  response in
                guard let self = self else { return }
                self.isLoading = false
                self.errorMessage = response.response?.errors?.first?.errorFields?.first?.value ??  response.response?.errors?.first?.message ?? ""
                self.successMessage = response.response?.data?.storeProperty?.message ?? ""
                if let payment = response.response?.data?.storeProperty?.payment,
                   let customer = response.response?.data?.storeProperty?.payment?.cart_id,
                   customer != "" {
                    paymentResult = payment
                    self.isShowPayment = true
                } else {
                    if let success = response.response?.data?.storeProperty?.status  {
                        self.isAddSubmitSuccess = (success == "success")
                    }
                }
            }
        }
        
        func updateCarSubmit(formId: Int, request: [String: Any?]) {
            self.isLoading = true
            ViewModel.apiHandler.updateMotorCars(formId: formId, request: request) { [weak self]  response in
                guard let self = self else { return }
                self.isLoading = false
                if let success = response.response?.status {
                    self.isAddSubmitSuccess = (success == "success")
                }
            }
        }
        
        
        func getPropertyAdvDetail(request: ProductDetailsViewModel.GetProductDetailsRequest.Request) {
            self.isLoading = true
            propertyApiHandler.fetchAdDetails(productId: request.propertyId) { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                if let advResponse = response {
                    self.propertyData = advResponse.advObject
                    self.newCatIdVal = self.propertyData?.categoryID ?? 0
                    self.fetchDataList(request: CreateAdsFormViewModel.MakeGetFormRequest.Request(catId: self.propertyData?.categoryID ?? 0, steps: stepNum))
                }
            }
        }
        
        func getMotorDetails(request: CarDetailsViewModel.GetCarDetailsRequest.Request) {
            self.isLoading = true
            postedCarApiHandler.fetchCarDetails(carId: request.carId) { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                if let motorResponse = response {
                    self.motorData =   motorResponse.motorObject
                    self.newCatIdVal = self.motorData?.categoryID ?? 0
                    if let makeId = self.motorData?.makeId {
                        getMotorModel(makeId: trim(makeId))
                    }
                    
                    self.fetchDataList(request: CreateAdsFormViewModel.MakeGetFormRequest.Request(catId: self.motorData?.categoryID ?? 0, steps: 1))
                }
            }
        }
        
        func deleteImageApi(imageData: MediaModel){
            isLoading = true
            
            ViewModel.apiHandler.deleteFormImageApi(serviceType: serviceType.rawValue, imageId: imageData.id) { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    
                } else {
                    uploadedImages = uploadedImages.filter({$0.id != imageData.id})
                }
            }
        }
        
        func getMotorMake() {
            self.isLoading = true
            filterApiHandler.fetchCarMake(page: nil) { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                self.motorMakeList =   response
                motorMakeListName = response.map { $0.title}
            }
        }
        
        func getMotorModel(makeId: String ) {
            self.isLoading = true
            filterApiHandler.fetchCarModel(id: makeId) { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                self.motorModelList = response
                motorModelListName = response.map { $0.title ?? ""}
            }
        }
        
        func getStates() {
            filterApiHandler.fetchStateList() { [weak self] response, error in
                guard let self = self else { return }
                self.statesList =   response
                statesNameList = response.map { $0.name ?? $0.state_code ?? ""}
                if let coordinates = self.getFirstItemCoordinates() {
                    selectedLocation = coordinates
                } else {
                    print("No valid coordinates found for the first item.")
                }
            }
        }
        func getFirstItemCoordinates() -> CLLocationCoordinate2D? {
            guard let firstItem = statesList.last,
                  let latitude = firstItem.latitude,
                  let longitude = firstItem.longitude else {
                return nil
            }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}
