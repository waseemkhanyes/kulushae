//
//  CarDetailsView.swift
//  Kulushae
//
//  Created by ios on 01/04/2024.
//
import SwiftUI
struct CarDetailsView: View {
    
    @State var motorId: Int
    @State private var selectedImage: String = "icn_gallary"
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject var dataHandler = CarDetailsViewModel.ViewModel()
    @State var isFullscreenMap: Bool = false
    @State var isFullscreenImage: Bool = false
    @State var isAgentListSelected: Bool = false
    @State var isChatOpen: Bool = false
    @State var isHomeOpen: Bool = false
    @State private var showShareSheet = false
    @State  var isFromShareLink: Bool = false
    var onDismiss: (() -> Void)?
    @Environment(\.dismiss) var dismiss
    @Environment(\.safeAreaInsets) var safeAreaInsets
    var fromChat = false
    
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
                    if let userId = PersistenceManager.shared.loggedUser?.id  {
                        if(userId != dataHandler.motorObject.userID?.id) {
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
                        if(!(dataHandler.motorObject.userID?.email ?? "" ).isEmpty) {
                            Button(action: {
                                sendMail(mail: dataHandler.motorObject.userID?.email ?? "")
                            }) {
                                Image(uiImage: UIImage(named: "icn_mail_closed") ?? UIImage())
                                    .resizable()
                                    .frame(width: 28, height: 19)
                            }
                            Spacer()
                        }
                        if(!(dataHandler.motorObject.contactInfo ?? "" ).isEmpty) {
                            Button(action: {
                                callPhone(phoneNum: dataHandler.motorObject.contactInfo ?? "" )
                            }) {
                                Image(uiImage: UIImage(named: "icn_call") ?? UIImage())
                                    .resizable()
                                    .foregroundColor(.black)
                                    .frame(width: 28, height: 28)
                            }
                            Spacer()
                        }
                        if(!(dataHandler.motorObject.contactInfo ?? "" ).isEmpty) {
                            Button(action: {
                                sendWhatsapp(phoneNum: dataHandler.motorObject.contactInfo ?? "")
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
                dataHandler.getMotorDetails(request: CarDetailsViewModel.GetCarDetailsRequest.Request(carId: self.motorId))
            }
            .sheet(isPresented: $showShareSheet) {
                ActivityViewController(activityItems: ["Check out this product", URL(string: "https://kulshae.com/motors/\(self.motorId)")!])
            }
            NavigationLink("", destination: ImagesVerticalListScreenView(images: $dataHandler.motorObject.images ), isActive: $isFullscreenImage)
            
            //            NavigationLink("", destination: ImageSlider(isFullscreen: $isFullscreenImage, images: $dataHandler.motorObject.images ), isActive: $isFullscreenImage)
            
            
            //            NavigationLink("", destination: MapDetailsView(isFullscreen: $isFullscreenMap, coordinateString: dataHandler.motorObject.location ?? "", selectedPlace: dataHandler.motorObject.neighbourhood ?? ""),
            //                           isActive: $isFullscreenMap)
            //            NavigationLink("", destination: CarsSearchResultView(user_id: Int(dataHandler.motorObject.userID?.id ?? ""), selectedCatId: "0"),isActive: $isAgentListSelected)
            NavigationLink(
                "",
                destination: CarListScreenView(
                    dataHandler: .init(
                        categoryId: "0",
                        search: "",
                        userId: Int(dataHandler.motorObject.userID?.id ?? "")
                    )
                ),
                isActive: $isAgentListSelected
            )
            NavigationLink("", destination: MotorChatViewDetails(isFromNotification: .constant(false), productId: motorId, chatFrom: "motor"),
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
                Text(String(format: "%.0f", dataHandler.motorObject.price ?? 0.0))
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
        }
    }
    
    var scrollContentView: some View {
        ObservableScrollView(showsIndicators: false, scrollOffset: $dataHandler.scrollOffset) { _ in
            VStack() {
                VStack {
                    if(selectedImage == "icn_gallary" ) {
                        ImageSlider(isFullscreen: $isFullscreenImage, images: $dataHandler.motorObject.images )
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
                        }
                        label: {
                            Image( (dataHandler.motorObject.isFavorite ?? false) ? "whish_filled" :  "wish")
                        }
                        .frame(width: 30, height: 30)
                        .zIndex(2.0)
                    }
                    .padding(.horizontal, 10)
                    .offset(y: -100)
                }
                .frame(height: 252)
                //                            HStack(alignment: .center) {
                //                                Spacer()
                //                                ImageTopDataBottomViewWithDot(text: "Photos", image: "icn_gallary", isSelected: selectedImage == "icn_gallary")
                //                                    .onTapGesture {
                //                                        selectedImage = "icn_gallary"
                //                                    }
                //                                Spacer()
                //                                ImageTopDataBottomViewWithDot(text: "Video", image: "icn_vedio", isSelected: selectedImage == "icn_vedio")
                //                                    .onTapGesture {
                //                                        selectedImage = "icn_vedio"
                //                                    }
                //                                //                                Spacer()
                //                                //                                ImageTopDataBottomViewWithDot(text: "Map", image: "icn_map", isSelected: selectedImage == "icn_map")
                //                                //                                    .onTapGesture {
                //                                //                                        selectedImage = "icn_map"
                //                                //                                    }
                //                                Spacer()
                //                                ImageTopDataBottomViewWithDot(text: "360", image: "icn_360", isSelected: selectedImage == "icn_360")
                //                                    .onTapGesture {
                //                                        selectedImage = "icn_360"
                //                                    }
                //                                Spacer()
                //                            }
                //                            .frame(height: 40)
                //                            .padding(.horizontal, 20)
                //                            .padding(.vertical, 15)
                
            }
            .background(Color.unselectedBorderColor)
            //                        .cornerRadius(15)
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 21) {
                    priceView
                    
                    HStack(spacing: 5){
                        Image("location_pin")
                            .scaledToFit()
                        
                        Text(dataHandler.motorObject.emirates ?? "")
                            .font(.Roboto.Regular(of: 16))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.gray)
                    }
                    
                    Text(dataHandler.motorObject.title ?? "")
                        .font(.Roboto.Bold(of: 20))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.black)
                }
                .padding(.horizontal, 16)
                
                HStack(alignment: .center) {
                    Spacer()
                    if(!(dataHandler.motorObject.year ?? "").isEmpty) {
                        MotorAditionalDataView(title: "Year", value: dataHandler.motorObject.year ?? "")
                    }
                    if(!(dataHandler.motorObject.kilometers ?? "").isEmpty) {
                        MotorAditionalDataView(title: "KILOMETER", value: dataHandler.motorObject.kilometers ?? "")
                    }
                    if(!(dataHandler.motorObject.specs ?? "").isEmpty) {
                        MotorAditionalDataView(title: "SPECS", value: dataHandler.motorObject.specs ?? "")
                    }
                    if(!(dataHandler.motorObject.steeringSide ?? "").isEmpty) {
                        MotorAditionalDataView(title: "Steering", value: dataHandler.motorObject.steeringSide ?? "")
                    }
                    Spacer()
                }
                
                Text(LocalizedStringKey("Information"))
                    .font(.Roboto.Bold(of: 20))
                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 16)
                    .padding(.top, 15)
                
                VStack(spacing: 10) {
                    HStack(spacing : 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(LocalizedStringKey("Make"))
                            
                            Text(LocalizedStringKey("Model"))
                            
                            Text(LocalizedStringKey("Trim"))
                            
                            Text(LocalizedStringKey("Body Type"))
                            
                            Text(LocalizedStringKey("Fuel Type"))
                                
                            Text(LocalizedStringKey("Seller type"))
                                
                            Text(LocalizedStringKey("Seating Capacity"))
                                
                            Text(LocalizedStringKey("Transmission Type"))
                                
                            Text(LocalizedStringKey("Engine Capacity (cc)"))
                                
                            Text(LocalizedStringKey("Number of Doors"))
                                
                            Text(LocalizedStringKey("Number of Cylinder"))
                                
                            Text(LocalizedStringKey("Horsepower"))
                        }
                        .font(.Roboto.Regular(of: 14))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.black.opacity(0.9))
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        
                        VStack(alignment: .leading, spacing: 10) {
                            InformationView(title: "Make", value: dataHandler.motorObject.make ?? "")
                            InformationView(title: "Model", value: dataHandler.motorObject.model ?? "")
                            InformationView(title: "Trim", value: dataHandler.motorObject.trim ?? "")
                            InformationView(title: "Body Type", value: dataHandler.motorObject.bodyType ?? "")
                            InformationView(title: "Fuel Type", value: dataHandler.motorObject.fuelType ?? "")
                            InformationView(title: "Seller type", value: dataHandler.motorObject.seller ?? "")
                            InformationView(title: "Seating Capacity", value: dataHandler.motorObject.seatingCapacity ?? "")
                            InformationView(title: "Transmission Type", value: dataHandler.motorObject.transmissionType ?? "")
                            InformationView(title: "Engine Capacity (cc)", value: dataHandler.motorObject.engineCapacity ?? "")
                            InformationView(title: "Number of Doors", value: dataHandler.motorObject.doors ?? "")
                            InformationView(title: "Number of Cylinder", value: dataHandler.motorObject.noOfCylinders ?? "")
                            InformationView(title: "Horsepower", value: dataHandler.motorObject.horsepwer ?? "")
                        }
                    }
                    
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 15)
                
                if(!(dataHandler.motorObject.desc ?? "").isEmpty) {
                    Text(LocalizedStringKey("Descriptions"))
                        .font(.Roboto.Bold(of: 20))
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .foregroundColor(Color.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                    
                    
                    Text(dataHandler.motorObject.desc ?? "")
                        .font(.Roboto.Medium(of: 14))
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .lineLimit(nil)
                        .padding(.horizontal, 16)
                }
                
                if dataHandler.motorObject.userID != nil {
                    AgentView(agentData: $dataHandler.motorObject.userID, isAgentListSelected: $isAgentListSelected)
                        .padding(.all, 16)
                        .padding(.bottom, 100)
                }
                
            }
            .padding(.top, 30)
        }
    }
    
    func addFavourite() {
        if(dataHandler.motorObject.isFavorite ?? false) {
            dataHandler.motorObject.isFavorite = false
        } else {
            dataHandler.motorObject.isFavorite = true
        }
        dataHandler.addFavDetails(request: CarDetailsViewModel.AddFavourite.Request(like: dataHandler.motorObject.isFavorite ?? false, itemId: self.motorId, type: dataHandler.motorObject.type ?? "" ))
        
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
        if let phoneURL = URL(string: "tel://\(dataHandler.motorObject.contactInfo ?? "")") {
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
            message = "I am contacting you about the \(trim(dataHandler.motorObject.title)) ad posted in Kulushae which priced at \(String(format: "%.0f", dataHandler.motorObject.price ?? 0.0)) AED."
        } else {
            message = "أنا أتواصل معك بخصوص إعلان \(trim(dataHandler.motorObject.title)) الذي تم نشره في كولوشاي والذي يُسعر بمبلغ \(String(format: "%.0f", dataHandler.motorObject.price ?? 0.0)) درهم."
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
//        if let url = URL(string: "whatsapp://send?phone=\(phoneNum)") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                // Handle the case where WhatsApp is not installed
//                print("WhatsApp is not installed.")
//            }
//        } else {
//            // Handle the case where the URL cannot be created
//            print("Unable to create WhatsApp URL.")
//        }
//    }
}
