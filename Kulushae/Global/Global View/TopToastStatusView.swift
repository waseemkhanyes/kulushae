//
//  TopToastStatusView.swift
//  Kulushae
//
//  Created by ios on 13/10/2023.
//

import SwiftUI

internal enum TopStatusToastType: Codable {
    case warning
    case success
    case faliure, error
    case info
    case custom
    case delete
}

internal enum DismissTimeType: Double, Codable {
    case short = 3.0
    case medium = 6.0
    case long = 9.0
    case never = -1.0
}

struct TopStatusToastView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State var message: String
    @State var type: TopStatusToastType = .info
    @State var dismissTime: DismissTimeType = .short
    // Internal States
    @State private var iconName: String = ""
    @State private var showMessagePopup: Bool = false
    @State private var backgroundGradient = Color.unselectedTextBackgroundColor
    @State private var bazelColor: Color = Color.black
    @State private var internalTimerCount: Double = 0.0
    // Internal States Controller using Timer
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    // Callback for touch Gesture.
    var didTapView: (() -> Void) = { }
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 20)
                Image(iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 26)
                    .onTapGesture {
                        if dismissTime != .never {
                            showMessagePopup = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                didTapView()
                            }
                        }
                    }
                Spacer().frame(width: 20)
                Text(LocalizedStringKey(message))
                    .font(.roboto_14())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(.black)
                    .padding(.vertical)
                Spacer()
            }
            .frame(width: .screenWidth * 0.9,
                   alignment: .center)
            .background(backgroundGradient)
            .zIndex(3.0)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(bazelColor, lineWidth: 1)
                    .onTapGesture {
                        if dismissTime != .never {
                            showMessagePopup = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                didTapView()
                            }
                        }
                    }
            )
            .onTapGesture {
                if dismissTime != .never {
                    showMessagePopup = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        didTapView()
                    }
                }
            }
            .onAppear {
                switch type {
                    case .warning:
                        iconName = "alert_warning"
                        backgroundGradient = .unselectedTextBackgroundColor
                        bazelColor = .white
                    case .success:
                        iconName = "success_alert"
                    backgroundGradient = .gray
                        bazelColor = .black
                    case .faliure, .error:
                        iconName = "alert_error"
                        backgroundGradient = .unselectedTextBackgroundColor
                        bazelColor = Color.red
                    case .info:
                        iconName = "alert_warning"
                        backgroundGradient = .unselectedTextBackgroundColor
                        bazelColor = .white
                    case .custom:
                        iconName = "alert_warning"
                        backgroundGradient = .unselectedTextBackgroundColor
                        bazelColor = .white
                    case .delete:
                        iconName = "alert_error"
                        backgroundGradient = .unselectedTextBackgroundColor
                        bazelColor = Color.black
                }
                showMessagePopup = true
                internalTimerCount = dismissTime.rawValue
            }
            .padding(.top, UIDevice.current.hasNotch ? 40 : 20)
            .offset(y: showMessagePopup ? 0 : -199)
            .animation(.linear(duration: 0.2),
                       value: showMessagePopup)

            Spacer()
        }
        .frame(width: .screenWidth,
               height: .screenHeight,
               alignment: .top)
        .onReceive(timer) { _ in
            if dismissTime != .never {
                internalTimerCount -= 1.0
                if internalTimerCount == 0 {
                    showMessagePopup = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        didTapView()
                    }
                }
            }
        }
    }
}

//#Preview {
//    TopStatusToastView()
//}
