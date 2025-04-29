//
//  PaymentViewControllerWrapper.swift
//  Kulushae
//
//  Created by ios on 03/04/2024.
//

import SwiftUI
import UIKit
import PaymentSDK


struct PaymentViewControllerWrapper: UIViewControllerRepresentable {
    var configuration: PaymentSDKConfiguration
    var delegate: PaymentManagerDelegate?
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController() // Placeholder view controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Implement updateUIViewController if needed
    }
    
    func presentPaymentScreen(on viewController: UIViewController) {
        PaymentManager.startCardPayment(on: viewController,
                                        configuration: configuration,
                                        delegate: delegate)
    }
}

class PaymentDelegate: PaymentManagerDelegate, ObservableObject {
    enum PaymentStatus {
        case success
        case failure
        case cancelled
        case none
    }
    
    @Published var paymentStatus: PaymentStatus = .none
    @Published var isPaymentSuccess: Bool = false
    @Published var errorMessage: String = ""
    var productType: String = ""
    
    func paymentManager(didFinishTransaction transactionDetails: PaymentSDK.PaymentSDKTransactionDetails?, error: (Error)?) {
        if let transactionDetails = transactionDetails {
            // Transaction was successful, print success response
            print("Transaction ID: \(transactionDetails.token)")
            callAfterPaymnetAPI(paymentInfo: transactionDetails) {_,_ in 
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.paymentStatus = .success
                self.isPaymentSuccess = true
            }
            
        } else if let error = error {
            // Transaction failed, print error response
            print("Error: \(error.localizedDescription)")
            errorMessage = "\(error.localizedDescription)"
            isPaymentSuccess = true
            self.paymentStatus = .failure
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    func paymentManager(didRecieveValidation error: (Error)?) {
        if let error = error {
            // Transaction failed, print error response
            errorMessage = "\(error.localizedDescription)"
            self.paymentStatus = .failure
            print("valida Error: \(error.localizedDescription)")
            
            guard let window = UIApplication.shared.keyWindow else { return }
            var topViewController = window.rootViewController
            
            while let presentedViewController = topViewController?.presentedViewController {
                topViewController = presentedViewController
            }
            
            if let topViewController = topViewController {
                let alertController = UIAlertController(title: "Payment Failed", message: errorMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAction)
                topViewController.present(alertController, animated: true)
            }
        }
    }
    
    func paymentManager(didStartPaymentTransaction rootViewController: UIViewController) {
        print("payment started")
        paymentStatus = .cancelled
    }
    
    func paymentManager(didCancelPayment error: (Error)?) {
        if let error = error {
            // Transaction failed, print error response
            print(" cancel Error: \(error.localizedDescription)")
        }
        paymentStatus = .cancelled
    }
    
    

        func callAfterPaymnetAPI(paymentInfo: PaymentSDK.PaymentSDKTransactionDetails,   completion: @escaping (String, Error?) -> Void) {
            let params: [String: String?] = [
                "currency_code": paymentInfo.cartCurrency,
                "country_code": paymentInfo.billingDetails?.countryCode,
                "cart_id": paymentInfo.cartID,
                "amount": paymentInfo.cartAmount ,
                "type":  self.productType,
                "customer_phone": paymentInfo.billingDetails?.phone,
                "customer_name" : paymentInfo.billingDetails?.name,
                "customer_email": paymentInfo.billingDetails?.email,
                "customer_address" : paymentInfo.billingDetails?.addressLine,
                "ip": nil
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("payment params after ", jsonString )
                    
                }
            } catch {
                print("Error converting parameters to JSON string: \(error)")
            }
            
            
            RestAPINetworkManager.shared.postRequest(url: Config.baseURL + Config.paymentAfterURL,
                                                     parameters: params
            ) { result in
                switch result {
                case .success(let data):
                    // Handle successful response
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Bool]
                        print(json)
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                    
                   
                case .failure(let error):
                    // Handle error
                    print("Error: \(error)")
                }
            }
        }
    
    
}


