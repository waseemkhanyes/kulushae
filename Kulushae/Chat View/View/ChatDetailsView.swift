//
//  ChatDetailsView.swift
//  Kulushae
//
//  Created by ios on 09/01/2024.
//

import SwiftUI
import Kingfisher
import Combine
import AVFAudio
import AVFoundation
import AVKit

struct ChatDetailsView: View {
    @StateObject var productDataHandler = ProductDetailsViewModel.ViewModel()
    @State var chatText: String = ""
    @State var receiverId: String = ""
    @State var categoryId: String = ""
    @State var isSender: Bool = false
    @StateObject var dataHandler = ChatViewModel.ViewModel()
    @Binding var isFromNotification: Bool
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) var dismiss
    @State var productId: Int
    @State var chatId: String = ""
    @State private var imageSource: ImageSource = .notSelected
    @State private var uploadedImages: [MediaModel] = []
    @State private var selectedImagePickerType: String = "image"
    @State private var progress: Double = 0.0
    @State private var isUploading = false
    @State var isOpenImageChooseView: Bool = false
    @State private var isTyping = false
    @State private var isRecordingVoice = false
    @State private var isSwipeToCancelActive = false
    @State private var audioRecorder: AVAudioRecorder!
    @State private var voiceDuration: String = "00:00"
    @State private var isBlinking = false
    @State private var isRecording = false
    @State private var timer: Timer?
    @State private var isPlaying = false
    @State private var player: AVPlayer?
    @State var chatFrom: String
    @State private var isFullScreenImagePresented = false
    @State private var selectedImageURL: URL? = nil
    @State var pressing = false
    @State var isDetailViewActive = false
    @State var chatData: GetChatModel? = nil
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationLink("", destination: PostedAdDetailsView(productId: productId, fromChat: true), isActive: $isDetailViewActive)
                .navigationBarBackButtonHidden(true)
            
            VStack(spacing: 0) {
                topView
                
                HStack() {
                    AsyncImage(url: URL(string: (Config.imageBaseUrl) + (productDataHandler.advObject.images?.first?.image ?? "") )) { image in
                        image
                            .resizable()
                            .frame(width: 100,  height: 100)
                            .scaledToFill()
                            .cornerRadius(15)
                    } placeholder: {
                        Image("default_property")
                            .resizable()
                            .frame(width: 100,  height: 100)
                            .cornerRadius(15)
                    }
                    .padding(.all, 15)
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(productDataHandler.advObject.title ?? "")
                            .font(.roboto_20())
                            .font(.headline.weight(.semibold))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black)
                        Text(String(format: "%.2f", productDataHandler.advObject.price ?? 0.0))
                            .font(.roboto_20())
                            .font(.headline.weight(.semibold))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black)
                            .padding(.bottom, 15)
                        Text(productDataHandler.advObject.neighbourhood ?? "")
                            .font(.roboto_14())
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    Spacer()
                }
                .frame(height: 120)
                .overlay(){
                    RoundedRectangle(cornerRadius: 20)
                        .inset(by: 0.5)
                        .stroke(.black.opacity(0.05), lineWidth: 1)
                }
                .padding(.top, 5)
                .padding(.horizontal, 16)
                .onTapGesture {
                    isDetailViewActive = true
                }
                
                GeometryReader {_ in
                    ScrollView {
                        ScrollViewReader { proxy in
                            LazyVStack(spacing: 25) {
                                ForEach(dataHandler.messages) { message in
                                    HStack {
                                        if message.isSender {
                                            Spacer()
                                            //                Button {
                                            //                    print("click on edit")
                                            //                } label: {
                                            //                    Image("chat_edit")
                                            //                }
                                            //                .padding(8)
                                            //                .cornerRadius(8)
                                            
                                        }
                                        
                                        HStack(alignment: .bottom) {
                                            
                                            if !message.isSender {
                                                KFImage(URL(string: dataHandler.receiverURL))
                                                    .placeholder {
                                                        Image("default_property")
                                                            .resizable()
                                                            .frame(width: 58,  height: 58)
                                                            .cornerRadius(39)
                                                            .shadow(radius: 10)
                                                    }
                                                    .resizable()
                                                    .frame(width: 58,  height: 58)
                                                    .cornerRadius(39)
                                                    .offset(y: 5)
                                            }
                                            VStack(alignment: !message.isSender ? .leading : .trailing) {
                                                if(message.type == "text") {
                                                    Text(message.message ?? "")
                                                        .padding( 15)
                                                        .font(.roboto_14_Medium())
                                                        .foregroundColor(message.isSender ? Color.black : Color.white)
                                                        .background(RoundedCornersShape(corners: message.isSender ? [.topLeft,
                                                                                                                     .topRight, .bottomLeft] : [.topLeft,
                                                                                                                                                .topRight, .bottomRight] , radius: 15)
                                                            .fill(message.isSender ? Color.white : Color.iconSelectionColor))
                                                        .shadow(color: .black.opacity(0.08), radius: 8, x: 8, y: 4)
                                                }
                                                if message.type == "image", let imageUrlString = message.message, let imageUrl = URL(string: (Config.imageBaseUrl + imageUrlString)) {
                                                    KFImage(imageUrl)
                                                    
                                                        .placeholder {
                                                            Image("default_property")
                                                                .resizable()
                                                                .frame(width: 100,  height: 100)
                                                                .cornerRadius(25)
                                                        }
                                                        .resizable()
                                                        .frame(width: 100,  height: 100)
                                                        .cornerRadius(25)
                                                        .onTapGesture {
                                                            selectedImageURL = imageUrl
                                                            isFullScreenImagePresented.toggle()
                                                        }
                                                        .fullScreenCover(isPresented: $isFullScreenImagePresented) {
                                                            if let selectedImageURL = selectedImageURL {
                                                                FullScreenImageView(imageURL: selectedImageURL)
                                                            }
                                                        }
                                                }
                                                if(message.type == "voice") {
                                                    VoiceMessageView(audioURL: URL(string: (Config.imageBaseUrl) +  (message.message ?? ""))!,
                                                                     isSender : message.isSender)
                                                    
                                                }
                                                if message.type == "video" {
                                                    ZStack {
                                                        KFImage(URL(string: ((Config.imageBaseUrl) + (message.message ?? ""))))
                                                            .placeholder {
                                                                Image("default_property")
                                                                    .resizable()
                                                                    .frame(width: 100,  height: 100)
                                                                    .cornerRadius(25)
                                                            }
                                                            .resizable()
                                                            .frame(width: 100, height: 100)
                                                            .cornerRadius(25)
                                                            .blur(radius: 5)
                                                        Button(action: {
                                                            if let videoURL = URL(string: ((Config.imageBaseUrl) + (message.message ?? ""))) {
                                                                let player = AVPlayer(url: videoURL)
                                                                let playerController = AVPlayerViewController()
                                                                playerController.player = player
                                                                UIApplication.shared.windows.first?.rootViewController?.present(playerController, animated: true) {
                                                                    player.play()
                                                                }
                                                            }
                                                        }) {
                                                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                                                .font(.system(size: 40))
                                                                .foregroundColor(.black.opacity(0.8))
                                                        }
                                                        .padding()
                                                    }
                                                }
                                                
                                                Text(message.createdAt ?? "")
                                                    .font(.roboto_14())
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            if message.isSender {
                                                KFImage(URL(string: dataHandler.senderURL))
                                                    .placeholder {
                                                        Image("default_property")
                                                            .resizable()
                                                            .frame(width: 58,  height: 58)
                                                            .cornerRadius(39)
                                                            .shadow(radius: 10)
                                                    }
                                                    .resizable()
                                                    .frame(width: 58,  height: 58)
                                                    .cornerRadius(39)
                                                    .offset(y: 5)
                                            }
                                            
                                        }
                                        
                                        if !message.isSender {
                                            //                Button {
                                            //                    print("click on edit")
                                            //                } label: {
                                            //                    Image("chat_edit")
                                            //                }
                                            //                .padding(8)
                                            //                .cornerRadius(8)
                                            Spacer()
                                        }
                                    }
                                    .id(message)
                                }
                            }
                            Spacer()
                                .frame(height: 15)
                                .onReceive(Just(dataHandler.messages.last)) { message in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation {
                                            proxy.scrollTo(message, anchor: .bottom)
                                        }
                                    }
                                }
                        }
                        
                    }
                    .padding(.horizontal, 15)
                }
                Spacer()
                VStack(alignment: .center) {
                    HStack {
                        if(!isRecordingVoice) {
                            Image(systemName: "paperclip")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .padding(.leading, 15)
                                .foregroundColor(.primary)
                                .onTapGesture {
                                    if isTyping {
                                        // Handle sending the text message
                                        sendMessage()
                                    } else {
                                        // Handle tapping paperclip (e.g., opening the image chooser)
                                        isOpenImageChooseView = true
                                    }
                                }
                        }
                        
                        if isRecordingVoice {
                            recordingView
                        } else {
                            
                            ZStack {
                                TextEditor(text: $chatText)
                                    .font(.roboto_14())
                                    .foregroundColor(Color.black)
                                    .frame(height: 40)
                                    .padding(.all, 15)
                                    .cornerRadius(15)
                                    .clipped()
                                    .cornerRadius(20, corners: .allCorners)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .onChange(of: chatText) { newValue in
                                        isTyping = !newValue.isEmpty
                                    }
                                Text(LocalizedStringKey("Start Typing.."))
                                    .font(.roboto_14())
                                    .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.gray)
                                    .opacity(chatText.isEmpty ? 1 : 0)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .padding(.horizontal, 5)
                                    .allowsHitTesting(false)
                            }
                            .frame(height: 40)
                        }
                        
                        Spacer()
                        
                        if isTyping  {
                            Image("chat_send")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .padding(.horizontal, 15)
                                .foregroundColor(.primary)
                                .onTapGesture {
                                    // Handle sending the text message
                                    sendMessage()
                                }
                        } else {
                            Button(action: {
                                // Cancel recording on release if already recording
                                if isRecording {
                                    endRecording()
                                }
                            }) {
                                Image(systemName: isRecording ? "mic.circle.fill" : "mic")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .padding(.all, 15)
                                    .foregroundColor(.primary)
                                    .font(isRecording ? .system(size: 30) : .system(size: 20))
                                    .scaleEffect(isRecording ? 3 : 1)
                            }
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        if value.location.x < -50 {
                                            stopRecordingVoice()
                                        }
                                    }
                            )
                            .simultaneousGesture( // Gesture to start recording on hold
                                LongPressGesture(minimumDuration: 0.1)
                                    .onEnded { _ in
                                        isRecording = true
                                        startRecordingVoice()
                                    }
                            )
                        }
                        
                    }
                    .padding(.top, 10)
                    Spacer()
                }
                
                .frame(width: .screenWidth, height: 100)
                .clipped()
                .cornerRadius(20, corners: .allCorners)
                .background(Color.unselectedTextBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius:20))
                .sheet(isPresented: .constant(imageSource != .notSelected )) {
                    ImagePickerView(numOfSelectedPictures: uploadedImages.count, images: $uploadedImages, isUploading: $isUploading, fromView: "chat", typeKey: "CHAT_IMAGES_URL", sourceType: imageSource, chatId: dataHandler.chatIdVal != "" ?  dataHandler.chatIdVal : chatId, pickerType: $selectedImagePickerType)
                }
                .onChange(of: isUploading) { isUploading in
                    // Reset progress when starting a new upload
                    if isUploading {
                        progress = 0.0
                        hideKeyboard()
                        
                    }
                }
                .onChange(of: uploadedImages) { isUploading in
                    isOpenImageChooseView = false
                    imageSource = .notSelected
                    dataHandler.sentMessage(
                        serviceType: trim(productDataHandler.advObject.type),
                        type: selectedImagePickerType,
                        message: uploadedImages.map { $0.fileName }.joined(separator: ","),
                        itemData: productDataHandler.advObject,
                        receiverId: isFromNotification ? receiverId : productDataHandler.advObject.userID?.id ?? "",
                        chatId:  dataHandler.chatIdVal != "" ?  dataHandler.chatIdVal : chatId
                                            
                    )
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        let messageData = ChatMessage(
                            receiverID: Int(isFromNotification ? receiverId : productDataHandler.advObject.userID?.id ?? "") ?? 0,
                            senderID: Int(PersistenceManager.shared.loggedUser?.id ?? "") ?? 0,
                            chatID: Int(chatId),
                            type: selectedImagePickerType,
                            message: uploadedImages.map { $0.url ?? ""}.joined(separator: ",") + "/" + uploadedImages.map { $0.fileName }.joined(separator: ","),
                            createdAt: Date().string(format: "YYYY-MM-DD HH:mm:ss"),
                            isSender: true
                        )
                        dataHandler.messages.append(messageData)
                        chatText = ""
                    }
                    
                }
                
            }
            .padding(.horizontal, 15)
            BottomSheetView(isOpen: $isOpenImageChooseView,
                            maxHeight: 250) {
                ImageChooseView(selectedPicType: $imageSource, isOpen: $isOpenImageChooseView)
                
            }.edgesIgnoringSafeArea(.all)
                .frame(width: .screenWidth,
                       height: isOpenImageChooseView ? .screenHeight   : 0.0,
                       alignment: .bottom)
                .opacity(isOpenImageChooseView ? 1.0 : 0.0)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        
        
        .onAppear() {
            productDataHandler.getAdvDetails(request: ProductDetailsViewModel.GetProductDetailsRequest.Request(propertyId: self.productId))
            if let chatData = self.chatData, !dataHandler.isFirstCall {
                dataHandler.isFirstCall = true
                dataHandler.setSenderProfile(userID: chatData.senderID ?? 0, isSender: true)
                dataHandler.setSenderProfile(userID: chatData.receiverID ?? 0, isSender: false)
            }
            
            if(isFromNotification) {
                dataHandler.setupPusher(senderId: PersistenceManager.shared.loggedUser?.id  ?? "",
                                        catId: categoryId,
                                        itemId: "\(self.productId)",
                                        receiverId: receiverId)
                dataHandler.getOldChatMessages(senderId: PersistenceManager.shared.loggedUser?.id  ?? "",
                                               catId: categoryId,
                                               itemId: "\(self.productId)",
                                               receiverId: receiverId,
                                               chatId: Int(self.chatId) )
            }
            
        }
        .onDisappear() {
            dataHandler.chennelDisconnect(dataHandler.channelName)
        }
        .onChange(of: productDataHandler.advObject) { advObject in
            if(!isFromNotification) {
                dataHandler.setupPusher(senderId: PersistenceManager.shared.loggedUser?.id  ?? "",
                                        catId: "\(productDataHandler.advObject.categoryID ?? 0)",
                                        itemId: "\(self.productId)",
                                        receiverId: productDataHandler.advObject.userID?.id ?? "0")
                dataHandler.getOldChatMessages(senderId: PersistenceManager.shared.loggedUser?.id  ?? "",
                                               catId: "\(productDataHandler.advObject.categoryID ?? 0)",
                                               itemId: "\(self.productId)",
                                               receiverId: productDataHandler.advObject.userID?.id ?? "0",
                                               chatId: Int(self.chatId) )
            }
            
        }
    }
    
    var topView: some View {
        HStack(spacing: 0) {
            Button(action: {
                if(isFromNotification) {
                    isFromNotification = false
                }
                dismiss()
                
                PusherManager.shared.unSubscribeAll()
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
            }
            .padding(.leading, 9)
            
            Spacer()
        }
        .frame(height: 50)
        .padding(.top, safeAreaInsets.top)
//        .shadowColor(show: dataHandler.scrollOffset > 0.0)
    }
    
    var recordingView: some View {
        HStack(spacing: 10) {
            // Button containing microphone image
            Button(action: {
                // Start recording
            }) {
                Image(systemName: "mic.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.red)
                    .opacity(isBlinking ? 0 : 1)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true))
            }
            .padding(.leading, 15)
            Spacer()
            // Text element with swipe gesture
            Text(LocalizedStringKey("Swipe left to cancel"))
                .foregroundColor(.gray)
                .font(.roboto_10())
                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                .padding(.all, 5)
                .gesture(
                    DragGesture(minimumDistance: 20, coordinateSpace: .local)
                        .onChanged { value in
                            // Update UI based on swipe progress (e.g., change color, show progress bar)
                            if value.translation.width > 0 { // Swiping left
                                let progress = min(value.translation.width / 100, 1.0)
                                // Update visual feedback here
                            }
                        }
                        .onEnded { value in
                            if value.translation.width > 100 { // Swiped past threshold
                                // Cancel recording
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                isRecording = false
                                stopRecordingVoice()
                            }
                        }
                )
            
            
        }
        .onAppear {
            startBlinking()
        }
        .onDisappear {
            stopBlinking()
        }
    }
    
    var swipeGesture: some Gesture {
        
        DragGesture(minimumDistance: 1, coordinateSpace: .local)
            .onChanged { value in
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                isRecordingVoice = false
                stopRecordingVoice()
            }
            .onEnded { _ in
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                isRecordingVoice = false
                stopRecordingVoice()
            }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    func sendMessage() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        dataHandler.sentMessage(
            serviceType: trim(productDataHandler.advObject.type),
            type: "text",
            message: chatText,
            itemData: productDataHandler.advObject,
            receiverId: isFromNotification ? receiverId : productDataHandler.advObject.userID?.id ?? "",
            chatId:  dataHandler.chatIdVal != "" ?  dataHandler.chatIdVal : chatId
        )
        
        let messageData = ChatMessage(
            receiverID: Int(isFromNotification ? receiverId : productDataHandler.advObject.userID?.id ?? "") ?? 0,
            senderID: Int(PersistenceManager.shared.loggedUser?.id ?? "") ?? 0,
            chatID: Int(chatId),
            type: "text",
            message: chatText,
            createdAt: Date().string(format: "YYYY-MM-DD HH:mm:ss"),
            isSender: true
        )
        dataHandler.messages.append(messageData)
        chatText = ""
    }
    
    func startRecordingVoice() {
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.record, mode: .default, options: [])
            try audioSession.setActive(true)
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentsPath.appendingPathComponent("recording.m4a")
            
            let settings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            // Use optional binding to safely unwrap the result of AVAudioRecorder initialization
            if let recorder = try? AVAudioRecorder(url: audioFilename, settings: settings) {
                DispatchQueue.main.async {
                    self.audioRecorder = recorder
                    self.audioRecorder.record()
                    self.isRecordingVoice = true
                    self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                        self.updateVoiceDuration()
                    }
                }
            } else {
                // Handle initialization failure (e.g., display an error message)
                print("Error: Unable to initialize AVAudioRecorder")
            }
        } catch {
            // Handle errors
            print("Error starting audio recording: \(error.localizedDescription)")
        }
    }
    
    
    func startBlinking() {
        withAnimation {
            isBlinking = true
        }
    }
    
    func stopBlinking() {
        withAnimation {
            isBlinking = false
        }
    }
    func triggerHapticFeedback() {
        let impactGenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactGenerator.prepare()
        impactGenerator.impactOccurred()
    }
    func updateVoiceDuration() {
        guard let audioRecorder = audioRecorder else {
            return
        }
        
        let currentTime = audioRecorder.currentTime
        let minutes = Int(currentTime / 60)
        let seconds = Int(currentTime) % 60
        
        voiceDuration = String(format: "%02d:%02d", minutes, seconds)
    }
    private func endRecording() {
        print("Recording ended")
        isRecording = false
        
        audioRecorder?.stop()
        //        audioRecorder = nil
        voiceDuration = "00:00"
        timer?.invalidate()
        timer = nil
        isRecordingVoice = false
        uploadVoiceMessage()
    }
    func stopRecordingVoice() {
        audioRecorder?.stop()
        isRecordingVoice = false
        isRecordingVoice = false
        voiceDuration = "00:00"
        timer?.invalidate()
        timer = nil
        isRecording = false
        // Additional logic if needed
    }
    
    func uploadVoiceMessage() {
        guard let audioFileURL = audioRecorder?.url else {
            // Handle the case when there is no recorded audio file
            print("Error: No recorded audio file found")
            return
        }
        DispatchQueue.main.async {
            self.isUploading = true
        }
        guard let url = URL(string: Config.baseURL + Config.imageUploadUrl) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        // Add Authorization header with Bearer token
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: Keys.Persistance.authKey.rawValue) ?? "")", forHTTPHeaderField: "Authorization")
        do {
            let audioData = try Data(contentsOf: audioFileURL)
            var body = Data()
            // Add audio data
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"recording.m4a\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
            body.append(audioData)
            body.append("\r\n".data(using: .utf8)!)
            // Add type data
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"type\"\r\n\r\n".data(using: .utf8)!)
            body.append("CHAT_IMAGES_URL".data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
            
            // Add chat_id data if available
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"chat_id\"\r\n\r\n".data(using: .utf8)!)
            body.append(chatId.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
            
            
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            
            let task = URLSession.shared.dataTask(with: request) {
                data,
                response,
                error in
                if let error = error {
                    print("Error uploading audio: \(error)")
                    // Handle the error (e.g., show an alert to the user)
                    DispatchQueue.main.async {
                        self.isUploading = false
                    }
                    return
                }
                
                guard let data = data else {
                    print("No data received from the server")
                    // Handle the absence of data (e.g., show an alert to the user)
                    DispatchQueue.main.async {
                        self.isUploading = false
                    }
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let fileName = json["file_name"] as? String {
                            let url = json["url"] as? String ?? ""
                            dataHandler.sentMessage(
                            serviceType: trim(productDataHandler.advObject.type),
                            type: "voice",
                            message: fileName,
                            itemData: productDataHandler.advObject,
                            receiverId: isFromNotification ? receiverId : productDataHandler.advObject.userID?.id ?? "",
                            chatId:  dataHandler.chatIdVal != "" ?  dataHandler.chatIdVal : chatId
                                                    
                            )
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                let messageData = ChatMessage(
                                    receiverID: Int(isFromNotification ? receiverId : productDataHandler.advObject.userID?.id ?? "") ?? 0,
                                    senderID: Int(PersistenceManager.shared.loggedUser?.id ?? "") ?? 0,
                                    chatID: Int(chatId),
                                    type: "voice",
                                    message: url + "/" + fileName,
                                    createdAt: Date().string(format: "YYYY-MM-DD HH:mm:ss"),
                                    isSender: true
                                )
                                dataHandler.messages.append(messageData)
                                chatText = ""
                            }
                            
                        } else {
                            print("Missing 'file_name' in the JSON response")
                            // Handle the absen`ce of 'file_name' (e.g., show an alert to the user)
                            DispatchQueue.main.async {
                                self.isUploading = false
                            }
                        }
                    } else {
                        print("Failed to parse JSON response")
                        // Handle the failure to parse JSON (e.g., show an alert to the user)
                        DispatchQueue.main.async {
                            self.isUploading = false
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                    // Handle the error (e.g., show an alert to the user)
                    DispatchQueue.main.async {
                        self.isUploading = false
                    }
                }
            }
            
            task.resume()
        } catch {
            print("Error reading audio file: \(error)")
            // Handle the error (e.g., show an alert to the user)
            DispatchQueue.main.async {
                self.isUploading = false
            }
        }
    }
}

