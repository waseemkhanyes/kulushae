//
//  AdDetailsViewModel.swift
//  Kulushae
//
//  Created by ios on 30/10/2023.
//

//import Foundation
//import Apollo
//import StripePaymentSheet
//import UIKit
//
//enum AdDetailsViewModel {
//    
//    // MARK: Use cases
//    
//    enum MakeGetFormRequest {
//        
//        struct Request: Codable {
//            var catId: Int
//            var steps: Int?
//        }
//        
//        struct Response: Codable {
//            var formData: [FetchFormDataModel]
//        }
//    }
//    
//    
//    enum MakeGetAmenitiesRequest {
//        
//        struct Response: Codable {
//            var amenityData: [AmenityList]
//        }
//    }
//    
//    enum MakeAdSubmit{
//        
//        struct Response: Codable {
//            var response: SubmitResponseModel?
//        }
//    }
//    
//    class ViewModel: ObservableObject {
//        
//        private static let apiHandler = AdDetailsWebService()
//        @Published var amenityData: [AmenityList] = []
//        @Published var formData: [[FetchFormDataModel]] = []
//        @Published var isLoading: Bool = false
//        @Published var isAmenityChosen = false
//        @Published var errorMessage: String = ""
//        @Published var successMessage: String = ""
//        @Published var isAddSubmitSuccess: Bool = false
//        //        @Published var paymentSheet: PaymentSheet?
//        @Published var paymentResult: PaymentModel?
//        @Published var isShowPayment: Bool = false
//        
//        var mapController: MapViewController? = nil
//        
//        // call to network functions
//        func fetchDataList(request: AdDetailsViewModel.MakeGetFormRequest.Request) {
//            self.isLoading = true
//            
//            ViewModel.apiHandler.fetchFormDataList(catId: request.catId, steps: request.steps) { [weak self] response, error in
//                guard let self = self else { return }
//                self.isLoading = false
//                if let formResponse = response {
//                    self.formData = formResponse
//                }
//            }
//        }
//        
//        func getAmenityList(isFromFilter: Bool = false) {
//            self.isLoading = true
//            self.amenityData = []
//            ViewModel.apiHandler.fetchAmenityDataList { [weak self] response, error in
//                guard let self = self else { return }
//                self.isLoading = false
//                if let amenityData = response {
//                    self.amenityData = amenityData
//                    if((amenityData.count > 0) && (!isFromFilter)) {
//                        isAmenityChosen = true
//                    } else {
//                        isAmenityChosen = false
//                    }
//                }
//            }
//        }
//        
//        func getMotorList(isFromFilter: Bool = false) {
//            self.isLoading = true
//            self.amenityData = []
//            ViewModel.apiHandler.fetchMotorDataList { [weak self] response, error in
//                guard let self = self else { return }
//                self.isLoading = false
//                if let amenityData = response {
//                    self.amenityData = amenityData
//                    if((amenityData.count > 0) && (!isFromFilter)) {
//                        isAmenityChosen = true
//                    } else {
//                        isAmenityChosen = false
//                    }
//                }
//            }
//        }
//        
//        func advSubmission(request: [String: Any?]) {
//            self.isLoading = true
//            ViewModel.apiHandler.submitAdvertisement(request: request) { [weak self]  response in
//                guard let self = self else { return }
//                self.isLoading = false
//                self.errorMessage = response.response?.errors?.first?.errorFields?.first?.value ??  response.response?.errors?.first?.message ?? ""
//                self.successMessage = response.response?.data?.storeProperty?.message ?? ""
//                if let payment = response.response?.data?.storeProperty?.payment,
//                   let customer = response.response?.data?.storeProperty?.payment?.cart_id,
//                   customer != "" {
//                    paymentResult = payment
//                    self.isShowPayment = true
//                } else {
//                    if let success = response.response?.data?.storeProperty?.status  {
//                        self.isAddSubmitSuccess = (success == "success")
//                    }
//                }
//            }
//        }
//        
//        func carSubmission(request: [String: Any?]) {
//            self.isLoading = true
//            ViewModel.apiHandler.submitCars(request: request) { [weak self]  response in
//                guard let self = self else { return }
//                self.isLoading = false
//                self.errorMessage = response.response?.errors?.first?.errorFields?.first?.value ??  response.response?.errors?.first?.message ?? ""
//                self.successMessage = response.response?.data?.storeProperty?.message ?? ""
//                if let payment = response.response?.data?.storeProperty?.payment,
//                   let customer = response.response?.data?.storeProperty?.payment?.cart_id,
//                   customer != "" {
//                    paymentResult = payment
//                    self.isShowPayment = true
//                } else {
//                    if let success = response.response?.data?.storeProperty?.status  {
//                        self.isAddSubmitSuccess = (success == "success")
//                    }
//                }
//            }
//        }
//        
//        //        func onPaymentCompletion(result: PaymentSheetResult) {
//        //            self.paymentResult = result
//        //        }
//        //
//        //        func presentPaymentSheet(from viewController: UIViewController) {
//        //            if let paymentSheet = self.paymentSheet {
//        //                paymentSheet.present(from: viewController) { paymentResult in
//        //                    self.onPaymentCompletion(result: paymentResult)
//        //                }
//        //            }
//        //        }
//    }
//}
