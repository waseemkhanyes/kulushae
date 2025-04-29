//
//  PaymentView.swift
//  Kulushae
//
//  Created by ios on 03/04/2024.
//

import SwiftUI
import PaymentSDK


struct PaymentView: View {
    var configuration: PaymentSDKConfiguration 
    var delegate: PaymentManagerDelegate?
//    var paymentCallbackURL : String? = "https://webhook.site/0ceb31ee-cdcd-48da-8bd5-d884ae38ee3b"
    var body: some View {
        PaymentViewControllerWrapper(configuration: configuration)
            .onAppear {
                // Use DispatchQueue to ensure that the presentation is delayed
                DispatchQueue.main.async {
                    if let viewController = UIApplication.shared.windows.first?.rootViewController {
                        // Ensure that the root view controller is part of the window hierarchy
                        configuration.showBillingInfo = true
//                        configuration.callbackURL = paymentCallbackURL
                        PaymentViewControllerWrapper(configuration: configuration, delegate: delegate).presentPaymentScreen(on: viewController)
                    }
                }
            }
    }
}
