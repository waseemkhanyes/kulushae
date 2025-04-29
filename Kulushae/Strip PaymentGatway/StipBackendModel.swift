//
//  StipBackendModel.swift
//  Kulushae
//
//  Created by ios on 14/12/2023.
//

import Foundation
import StripePaymentSheet
import SwiftUI
//
//enum PaymentResult {
//    case success
//    case cancelled
//    case failed(Error)
//}

//struct PaymentSheetView: UIViewControllerRepresentable {
//    var paymentSheet: PaymentSheet?
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        let controller = UIViewController()
//        // Additional modifications if needed
//        // For example, you can add an overlay to indicate loading while waiting for the PaymentSheet
//        
//        // Present PaymentSheet with a delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            paymentSheet?.present(from: controller) { result in
//                switch result {
//                case .completed:
//                    print("Your order is confirmed")
//                case .canceled:
//                    print("Canceled!")
//                case .failed(let error):
//                    print("Payment failed: \(error)")
//                }
//            }
//        }
//        
//        return controller
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//}
//
//
//
//
//struct PaymentSheetWrapper: UIViewControllerRepresentable {
//    var paymentSheet: PaymentSheet?
//    var onPaymentStatusChanged: ((PaymentResult) -> Void)?
//    
//    @State private var isSheetPresented = false
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        return UIViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        DispatchQueue.main.async {
//            guard !self.isSheetPresented else {
//                // The sheet is already presented, do not attempt to present it again
//                return
//            }
//            
//            if let viewController = UIApplication.shared.windows.first?.rootViewController {
//                self.isSheetPresented = true
//                
//                self.paymentSheet?.present(from: viewController) { result in
//                    switch result {
//                    case .completed:
//                        self.onPaymentStatusChanged?(.success)
//                    case .canceled:
//                        self.onPaymentStatusChanged?(.cancelled)
//                    case .failed(let error):
//                        self.onPaymentStatusChanged?(.failed(error))
//                    }
//                    
//                    // Reset the flag after the sheet is dismissed
//                    self.isSheetPresented = false
//                }
//            }
//        }
//    }
//}
