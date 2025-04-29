//
//  MapSearchTextField.swift
//  Kulushae
//
//  Created by Waseem  on 16/01/2025.
//

import SwiftUI
import Combine

struct MapSearchTextField: View {
    @EnvironmentObject var languageManager: LanguageManager
    var placeholder: String = ""
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    private var borderColor: Color {
        isFocused ? .black : .unselectedBorderColor
    }
    
    let didGetValue: (String) -> Void
    
    // Add a cancellable to store the timer
    @State private var debounceCancellable: AnyCancellable?
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .center, spacing: 10) {
                    
                    ZStack(alignment: .leading) {
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text(LocalizedStringKey(placeholder))
                                .foregroundColor(Color.gray)
                                .font(.Roboto.Regular(of: 14))
                                .scaleEffect(text.isEmpty ? 1.0 : 0.9, anchor: .leading)
                                .animation(.spring(), value: text.isEmpty)
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                .background(.white)
                                .offset(y: text.isEmpty ? 0 : -20)
                            
                            TextField(text, text: $text)
                                .onChange(of: text) { newValue in
                                    // Cancel the previous debounce if any
                                    debounceCancellable?.cancel()
                                    
                                    // Add a new debounce with a 0.2-second delay
                                    debounceCancellable = Just(newValue)
                                        .delay(for: .milliseconds(400), scheduler: DispatchQueue.main)
                                        .sink { delayedValue in
                                            print("** wk delayedValue: \(delayedValue)")
                                            didGetValue(delayedValue)
                                        }
                                }
                                .font(.roboto_14())
                                .foregroundColor(.black)
                                .frame(height: text.isEmpty ? 0.0 : nil)
                                .offset(y: text.isEmpty ? -10 : -10)
                                .focused($isFocused)
                        }
                        
                    }
                    .font(.Roboto.Regular(of: 16))
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .frame(height: 40, alignment: .center)
                    
                    Spacer()
                    
                }
                .padding(.all, 10)
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(borderColor,
                                    lineWidth: 1))
                        .padding(.horizontal, 1)
                )
            }
        }
    }
}


//import SwiftUI
//import Combine
//
//struct MapSearchTextField: View {
//    @EnvironmentObject var languageManager: LanguageManager
//    var placeholder: String = ""
//    @State var selectedDate: String = ""
//
//    @FocusState private var isFocused: Bool
//    private var borderColor: Color {
//        isFocused ? .black : .unselectedBorderColor
//    }
//
//    let didGetValue: (String) -> Void
//
//    var body: some View {
//        ZStack {
//            VStack {
//                HStack(alignment: .center, spacing: 10) {
//
//                    ZStack(alignment: .leading) {
//
//                        VStack(alignment: .leading, spacing: 1) {
//                            Text(LocalizedStringKey(placeholder))
//                                .foregroundColor(Color.gray)
//                                .font(.Roboto.Regular(of: 14))
//                                .scaleEffect(selectedDate.isEmpty ? 1.0 : 0.9, anchor: .leading)
//                                .animation(.spring(), value: selectedDate.isEmpty)
//                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
//                                .background(.white)
//                                .offset(y: selectedDate.isEmpty ? 0 : -20)
//
//                            TextField(selectedDate, text: $selectedDate)
//                                .onChange(of: selectedDate) { newValue in
//                                    didGetValue(newValue)
//                                }
//                                .font(.roboto_14())
//                                .foregroundColor(.black)
//                                .frame(height: selectedDate.isEmpty ? 0.0 : nil)
//                                .offset(y: selectedDate.isEmpty ? -10 : -10)
//                                .focused($isFocused)
//                        }
//
//                    }
//                    .font(.Roboto.Regular(of: 16))
//                    .disableAutocorrection(true)
//                    .textInputAutocapitalization(.never)
//                    .frame(height: 40, alignment: .center)
//
//                    Spacer()
//
//                }
//                       .padding(.all, 10)
//                       .background(RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.white)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(borderColor,
//                                        lineWidth: 1))
//                            .padding(.horizontal, 1)
//                       )
//            }
//
//        }
//    }
//}
//
////#Preview {
////    MapSearchTextField()
////}
