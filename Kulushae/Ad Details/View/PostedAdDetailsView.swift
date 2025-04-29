//
//  PostedAdDetailsView.swift
//  Kulushae
//
//  Created by ios on 18/11/2023.
//

import SwiftUI
import CoreLocation

struct PostedAdDetailsView: View {
    
    @State var productId: Int
    @State private var selectedImage: String = "icn_gallary"
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject var dataHandler = ProductDetailsViewModel.ViewModel()
    @State var isFullscreenMap: Bool = false
    @State var isFullscreenImage: Bool = false
    @State var isAgentListSelected: Bool = false
    @State var isChatOpen: Bool = false
    @State var isHomeOpen: Bool = false
    @State private var showShareSheet = false
    @State  var isFromShareLink: Bool = false
    var fromChat: Bool = false
    var onDismiss: (() -> Void)?
    @Environment(\.dismiss) var dismiss
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    var body: some View {
        UILoader(isShowing: dataHandler.isLoading) {
            
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    topView
                    
                    scrollContentView
                    
                    Spacer()
                }
                .padding(.bottom, 100)
                
                if !fromChat {
                    if let userId = PersistenceManager.shared.loggedUser?.id {
                        if(userId != dataHandler.advObject.userID?.id) {
                            HStack {
                                Spacer()
                                Image(languageManager.currentLanguage == "ar" ? "chat_floating_ar": "chat_floating")
                                    .fixedSize()
                                    .frame(width: 92)
                                    .padding(.trailing, 15)
                                    .onTapGesture() {
                                        if(PersistenceManager.shared.userStates?.currentAuthState == .loggedIn) {
                                            isChatOpen = true
                                        } else {
                                            isHomeOpen = true
                                        }
                                        
                                    }
                            }
                            .padding(.bottom, 100)
                        }
                    } else {
                        HStack {
                            Spacer()
                            Image(languageManager.currentLanguage == "ar" ? "chat_floating_ar": "chat_floating")
                                .fixedSize()
                                .frame(width: 92)
                                .padding(.trailing, 15)
                                .onTapGesture() {
                                    if(PersistenceManager.shared.userStates?.currentAuthState == .loggedIn) {
                                        isChatOpen = true
                                    } else {
                                        isHomeOpen = true
                                    }
                                    
                                }
                        }
                        .padding(.bottom, 100)
                    }
                }
                
                ZStack(alignment: .center) {
                    HStack {
                        Spacer()
                        if(!(dataHandler.advObject.userID?.email ?? "" ).isEmpty) {
                            Button(action: {
                                sendMail(mail: dataHandler.advObject.userID?.email ?? "")
                            }) {
                                Image(uiImage: UIImage(named: "icn_mail_closed") ?? UIImage())
                                    .resizable()
                                    .frame(width: 28, height: 19)
                            }
                            Spacer()
                        }
                        if(!(dataHandler.advObject.contactNumber ?? "" ).isEmpty) {
                            Button(action: {
                                callPhone(phoneNum: dataHandler.advObject.contactNumber ?? "" )
                            }) {
                                Image(uiImage: UIImage(named: "icn_call") ?? UIImage())
                                    .resizable()
                                    .foregroundColor(.black)
                                    .frame(width: 28, height: 28)
                            }
                            Spacer()
                        }
                        if(!(dataHandler.advObject.contactNumber ?? "" ).isEmpty) {
                            Button(action: {
                                sendWhatsapp(phoneNum: dataHandler.advObject.contactNumber ?? "")
                            }) {
                                Image(uiImage: UIImage(named: "icn_whatsap") ?? UIImage())
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .foregroundColor(.clear)
                .frame(width: .screenWidth, height: 86)
                .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 23, x: 0, y: 4)
                
            }
            .cleanNavigationAndSafeArea()
            .onAppear(){
                dataHandler.getAdvDetails(request: ProductDetailsViewModel.GetProductDetailsRequest.Request(propertyId: self.productId))
            }
            .sheet(isPresented: $showShareSheet) {
                ActivityViewController(activityItems: ["Check out this product", URL(string: "https://kulshae.com/property/\(self.productId)")!])
            }
            NavigationLink("", destination: ImagesVerticalListScreenView(images: $dataHandler.advObject.images ), isActive: $isFullscreenImage)
            //            NavigationLink("", destination: ImageSlider(isFullscreen: $isFullscreenImage, images: $dataHandler.advObject.images ), isActive: $isFullscreenImage)
            NavigationLink("", destination: MapDetailsView(isFullscreen: $isFullscreenMap, coordinateString: dataHandler.advObject.location ?? "", selectedLocation: .constant(CLLocationCoordinate2D()), selectedPlace: .constant(dataHandler.advObject.neighbourhood ?? "")),
                           isActive: $isFullscreenMap)
            NavigationLink("", destination: PropertyListScreenView(dataHandler: .init(category: nil, userId: Int(dataHandler.advObject.userID?.id ?? ""))), isActive: $isAgentListSelected)
            
            //            NavigationLink("", destination: SearchResultView(user_id: Int(dataHandler.advObject.userID?.id ?? ""), selectedCatId: "0"), isActive: $isAgentListSelected)
            
            NavigationLink("", destination: ChatDetailsView(isFromNotification: .constant(false), productId: productId, chatFrom: "property"),
                           isActive: $isChatOpen)
            NavigationLink("", destination: MainView(isLoginOpen: true),
                           isActive: $isHomeOpen)
            .navigationBarBackButtonHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    var topView: some View {
        HStack {
            Button(action: {
                if(isFromShareLink) {
                    onDismiss?()
                } else {
                    dismiss()
                }
            }) {
                VStack(spacing: 0) {
                    Image("back")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 15, alignment: .center)
                        .clipped()
                        .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
                }
                .frame(width: 35, height: 35)
                .padding(.leading, 8)
            }
            
            Text(LocalizedStringKey("Detail"))
                .font(.Roboto.Medium(of: 22))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
            
            
            Spacer()
            
            Button(action: {
                showShareSheet = true
            }) {
                VStack(spacing: 0) {
                    Image("share")
                }
                .frame(width: 35, height: 35)
                .padding(.trailing, 8)
            }
        }
        .frame(height: 50)
        .padding(.top, safeAreaInsets.top)
        .shadowColor(show: dataHandler.scrollOffset > 0.0)
    }
    
    var priceView: some View {
        HStack {
            HStack(alignment: .bottom, spacing: 5) {
                Text(String(format: "%.0f", dataHandler.advObject.price ?? 0.0))
                    .font(.Roboto.Bold(of: 28))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.black)
                
                Text(LocalizedStringKey("AED"))
                    .font(.Roboto.Medium(of: 18))
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.black)
            }
            
            Spacer()
            
            if(dataHandler.advObject.isFeatured ?? false) {
                Text(LocalizedStringKey("Featured"))
                    .padding(12)
                    .font(.roboto_18_bold())
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .font(.headline.weight(.semibold))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                    .background(Color.appPrimaryColor)
                    .cornerRadius(15)
            }
            //                                    if((PersistenceManager.shared.loggedUser?.id ?? "" ) == (dataHandler.advObject.userID?.id ?? "-1")) {
            //                                        Image("pencil")
            //                                            .padding(.horizontal, 15)
            //                                    }
        }
    }
    
    var mapView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(LocalizedStringKey("Map"))
                .font(.Roboto.Bold(of: 20))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .foregroundColor(Color.black)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            MapDetailsView(isFullscreen: $isFullscreenMap, coordinateString: dataHandler.advObject.location ?? "", selectedLocation: .constant(CLLocationCoordinate2D()), selectedPlace: .constant(dataHandler.advObject.neighbourhood ?? ""))
                .aspectRatio(375/200, contentMode: .fit)
            //                .frame(height: 252)
        }
        .padding(.horizontal, 16)
    }
    
    var scrollContentView: some View {
        ObservableScrollView(showsIndicators: false, scrollOffset: $dataHandler.scrollOffset) { _ in
            VStack() {
                VStack {
                    if(selectedImage == "icn_gallary" ) {
                        ImageSlider(isFullscreen: $isFullscreenImage, images: $dataHandler.advObject.images )
                    }
                    
                    if(selectedImage == "icn_vedio" ) {
                        if let socialmediaArray = dataHandler.advObject.socialmedia {
                            ForEach(socialmediaArray.filter { $0.type == "youtube_url" }, id: \.id) { socialmediaItem in
                                if let youtubeURLString = socialmediaItem.value, let youtubeURL = URL(string: youtubeURLString) {
                                    VideoSlider(videoURLs: [ youtubeURL])
                                }
                            }
                            if(socialmediaArray.filter { $0.type == "youtube_url" }.isEmpty) {
                                ZStack {
                                    Text(LocalizedStringKey("No Recorded Filim Found"))
                                        .font(.roboto_16())
                                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.gray)
                                }
                                .frame(width: .screenWidth, height: 250)
                            }
                        }
                        else {
                            ZStack {
                                Text(LocalizedStringKey("No Recorded Filim Found"))
                                    .font(.roboto_16())
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.black)
                            }
                            .frame(width: .screenWidth, height: 250)
                        }
                        
                    }
                    
                    if(selectedImage == "icn_360") {
                        ThreeSixtyImageView()
                            .frame(width: UIScreen.main.bounds.width, height: 250)
                            .scaledToFill()
                            .cornerRadius(15)
                            .clipped()
                            .overlay(
                                Image("icon_360_white")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.red)
                                    .opacity(0.8)
                            )
                    }
                    
                    
                }
                .overlay() {
                    HStack(spacing: 20) {
                        Spacer()
                        Button {
                            
                            if(PersistenceManager.shared.userStates?.currentAuthState == .loggedIn) {
                                addFavourite()
                            } else {
                                isHomeOpen = true
                            }
                        }       label: {
                            Image( (dataHandler.advObject.isFavorite ?? false) ? "whish_filled" :  "wish")
                        }
                        .frame(width: 30, height: 30)
                        .zIndex(2.0)
                    }
                    .padding(.horizontal, 10)
                    .offset(y: -100)
                }
                .frame(height: 252)
                
                HStack {
                    
                    ImageTopDataBottomViewWithDot(text: "Photos", image: "icn_gallary", isSelected: selectedImage == "icn_gallary")
                        .onTapGesture {
                            selectedImage = "icn_gallary"
                        }
                    Spacer()
                    ImageTopDataBottomViewWithDot(text: "Video", image: "icn_vedio", isSelected: selectedImage == "icn_vedio")
                        .onTapGesture {
                            selectedImage = "icn_vedio"
                        }
                    //                    Spacer()
                    //                    ImageTopDataBottomViewWithDot(text: "Map", image: "icn_map", isSelected: selectedImage == "icn_map")
                    //                        .onTapGesture {
                    //                            selectedImage = "icn_map"
                    //                        }
                    Spacer()
                    ImageTopDataBottomViewWithDot(text: "360", image: "icn_360", isSelected: selectedImage == "icn_360")
                        .onTapGesture {
                            selectedImage = "icn_360"
                        }
                    
                }
                .frame(height: 40)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                
            }
            .background(Color.unselectedBorderColor)
            //                        .cornerRadius(15)
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 21) {
                    priceView
                    
                    HStack(spacing: 5){
                        Image("location_pin")
                            .scaledToFit()
                        //                            .padding(.leading, 8)
                        
                        Text(dataHandler.advObject.neighbourhood ?? "")
                            .font(.Roboto.Regular(of: 16))
                        //                            .font(.headline.weight(.semibold))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.gray)
                    }
                    
                    Text(dataHandler.advObject.title ?? "")
                        .font(.Roboto.Bold(of: 20))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.black)
                    
                    
                }
                .padding(.horizontal, 16)
                
                HStack {
                    Spacer()
                    if(!(dataHandler.advObject.bathrooms ?? "").isEmpty) {
                        ImageTopDataBottomView(text: dataHandler.advObject.bathrooms ?? "", image: "bathroom")
                    }
                    if(!(dataHandler.advObject.bedrooms ?? "").isEmpty) {
                        ImageTopDataBottomView(text: dataHandler.advObject.bedrooms ?? "", image: "bedroom")
                    }
                    if(!(dataHandler.advObject.size ?? "").isEmpty) {
                        ImageTopDataBottomView(text: (dataHandler.advObject.size ?? "") + " Sqft", image: "sqrft")
                    }
                    Spacer()
                }
                
                if let amenities = dataHandler.advObject.amenities,
                   !amenities.isEmpty {
                    Text(LocalizedStringKey("Amenities"))
                        .font(.Roboto.Bold(of: 20))
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                    
                    ForEach(amenities.chunked(into: 3), id: \.self) { chunk in
                        HStack(spacing: 10) {
                            ForEach(chunk, id: \.self) { item in
                                HStack(spacing: 0) {
                                    AmentiesItemView(titleVal: item.title ?? "")
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                
                if(!(dataHandler.advObject.description_val ?? "").isEmpty) {
                    Text(LocalizedStringKey("Description"))
                        .font(.Roboto.Bold(of: 20))
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .foregroundColor(Color.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                    
                    Text(dataHandler.advObject.description_val ?? "")
                        .font(.Roboto.Medium(of: 14))
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .lineLimit(nil)
                        .padding(.horizontal, 16)
                }
                
                mapView
                
                if dataHandler.advObject.userID?.id != nil {
                    //                    AgentDetailsView(agentData: $dataHandler.advObject.userID, isAgentListSelected: $isAgentListSelected)
                    //                        .padding(.all, 16)
                    
                    AgentView(agentData: $dataHandler.advObject.userID, isAgentListSelected: $isAgentListSelected)
                        .padding(.all, 16)
                        .padding(.bottom, 100)
                }
                
            }
            .padding(.top, 30)
        }
    }
    
    func addFavourite() {
        if(dataHandler.advObject.isFavorite ?? false) {
            dataHandler.advObject.isFavorite = false
        } else {
            dataHandler.advObject.isFavorite = true
        }
        dataHandler.addFavDetails(request: ProductDetailsViewModel.AddFavourite.Request(like: dataHandler.advObject.isFavorite ?? false, itemId: self.productId, type: dataHandler.advObject.type ?? ""))
        
    }
    
    func sendMail(mail: String) {
        if let url = URL(string: "mailto:\(mail)") {
            UIApplication.shared.open(url)
        } else {
            // Handle the case where the URL cannot be created
            print("Unable to create mail URL.")
        }
    }
    
    func callPhone(phoneNum: String) {
        if let phoneURL = URL(string: "tel://\(dataHandler.advObject.contactNumber ?? "")") {
            UIApplication.shared.open(phoneURL)
        } else {
            // Handle the case where the URL cannot be created
            print("Unable to create phone call URL.")
        }
    }
    
    func sendWhatsapp(phoneNum: String) {
        // Format the phone number by removing spaces and trimming any whitespaces or newlines
        let formattedPhoneNumber = phoneNum.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
        
        // Encode the message to ensure it is URL-safe
        var message = ""
        let lang = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
        if lang == "en" {
            message = "I am contacting you about the \(trim(dataHandler.advObject.title)) ad posted in Kulushae which priced at \(String(format: "%.0f", dataHandler.advObject.price ?? 0.0)) AED."
        } else {
            message = "أنا أتواصل معك بخصوص إعلان \(trim(dataHandler.advObject.title)) الذي تم نشره في كولوشاي والذي يُسعر بمبلغ \(String(format: "%.0f", dataHandler.advObject.price ?? 0.0)) درهم."
        }
        
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Construct the URL with phone number and message
        if let url = URL(string: "whatsapp://send?phone=\(formattedPhoneNumber)&text=\(encodedMessage)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("WhatsApp is not installed on this device.")
                if let appStoreURL = URL(string: "https://apps.apple.com/us/app/whatsapp-messenger/id310633997") {
                    UIApplication.shared.open(appStoreURL)
                }
            }
        } else {
            print("Unable to create WhatsApp URL.")
        }
    }
    
    
//    func sendWhatsapp(phoneNum: String) {
//        let formattedPhoneNumber = phoneNum.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
//        
//        if let url = URL(string: "whatsapp://send?phone=\(formattedPhoneNumber)") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                print("WhatsApp is not installed on this device.")
//                if let appStoreURL = URL(string: "https://apps.apple.com/us/app/whatsapp-messenger/id310633997") {
//                    UIApplication.shared.open(appStoreURL)
//                }
//            }
//        } else {
//            print("Unable to create WhatsApp URL.")
//        }
//        
//        //        if let url = URL(string: "whatsapp://send?phone=\(phoneNum)") {
//        //            if UIApplication.shared.canOpenURL(url) {
//        //                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        //            } else {
//        //                // Handle the case where WhatsApp is not installed
//        //                print("WhatsApp is not installed.")
//        //            }
//        //        } else {
//        //            // Handle the case where the URL cannot be created
//        //            print("Unable to create WhatsApp URL.")
//        //        }
//    }
}

struct AgentView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var agentData: UserIDModel?
    @Binding var isAgentListSelected: Bool
    
    var strName: String {
        let first = agentData?.firstName ?? ""
        let last = agentData?.lastName ?? ""
        return "\(first) \(last)"
    }
    
    var body: some View {
        HStack(spacing: 0) {
            agentImageView
                .padding(.horizontal, 10)
                .padding(.vertical, 16)
            
            detailView
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        //        .frame(height: 171)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .inset(by: 0.5)
                .stroke(.black.opacity(0.5), lineWidth: 1)
            
        )
    }
    
    var agentImageView: some View {
        AsyncImage(url: URL(string: (Config.imageBaseUrl) + (agentData?.image ?? ""))) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(100, corners: .allCorners)
                
        } placeholder: {
            Image("imgUserPlaceHolder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipped()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 80)
                .inset(by: -0.5)
                .stroke(.black, lineWidth: 1))
    }
    
    var listedButtonView: some View {
        Button(action: {
            isAgentListSelected = true
        }) {
            HStack(spacing: 1){
                Text("\(agentData?.total_listings ?? 1) ")
                    .font(.Roboto.Regular(of: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                Text(LocalizedStringKey("Listed"))
                    .font(.Roboto.Regular(of: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                
                Image(.imgAgentArrow)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 17, height: 12)
                    .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
                    .padding(.leading, 10)
            }
            .frame(height: 40)
        }
        .padding(.horizontal, 16)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.5)
                .stroke(.black, lineWidth: 1)
        )
        .padding(.top, 10)
        
    }
    
    var detailView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(strName)
                .font(.Roboto.Bold(of: 18))
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
                .padding(.bottom, 5)
            
            Text(LocalizedStringKey("Member Since"))
                .font(.Roboto.Regular(of: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
            
            Text(agentData?.member_since ?? "")
                .font(.Roboto.Regular(of: 14))
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)
            
            listedButtonView
        }
        .padding(.vertical, 10)
    }
}

fileprivate struct AmentiesItemView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State var titleVal: String  = "name"
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(LocalizedStringKey(titleVal))
                .font(.Roboto.Regular(of: 14))
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.black)
                .padding(.horizontal)
                .lineLimit(2)
                .minimumScaleFactor(0.6)
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(Color.unselectedBorderColor)
        )
    }
}
