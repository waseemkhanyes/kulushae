import SwiftUI
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    let fromView: String
    let typeKey: String
    let chatId: String?
    let numOfSelectedPictures: Int // This is the number of selected photos
    @Binding var images: [MediaModel]
    @Binding var isUploading: Bool
    @Binding var imagePickerType : String
    var sourceType: ImageSource
    
    init(numOfSelectedPictures: Int, images: Binding<[MediaModel]>,  isUploading: Binding<Bool>, fromView: String, typeKey: String, sourceType: ImageSource, chatId: String? , pickerType: Binding<String>) {
        self.numOfSelectedPictures = numOfSelectedPictures
        self._images = images
        self._isUploading = isUploading
        self.fromView = fromView
        self.typeKey = typeKey
        self.sourceType = sourceType
        self.chatId = chatId
        self._imagePickerType = pickerType
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        if sourceType == .camera {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .camera
            //            if(fromView == "chat") {
            //                cameraPicker.mediaTypes = ["public.image", "public.movie"]
            //            } else {
            cameraPicker.mediaTypes = ["public.image"]
            //            }
            cameraPicker.delegate = context.coordinator
            return cameraPicker
        } else {
            // Configuration for photo library
            var maxNumOfPictures = 1
            if fromView == "profile" || fromView == "chat" {
                maxNumOfPictures = 1
            } else {
                maxNumOfPictures = 20 - self.numOfSelectedPictures
            }
            
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = maxNumOfPictures
            if(fromView == "chat") {
                configuration.filter = .any(of: [.images, .videos])
            } else {
                configuration.filter = .any(of: [.images])
            }
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = context.coordinator
            return picker as UIViewController
        }
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let pickerViewController = uiViewController as? PHPickerViewController {
            // Update the pickerViewController if needed
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(images: self.$images, isUploading: $isUploading, type: fromView, typeKey: self.typeKey , sourceType: self.sourceType, chatId: chatId ?? "", picketType: self.$imagePickerType)
    }
    
}

// MARK; - Coordinator + PHPickerViewControllerDelegate
extension ImagePickerView {
    
    final class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        @Binding var images: [MediaModel]
        @Binding var isUploading: Bool
        @State private var uploadProgress: Float = 0.0
        var type: String
        var typeKey: String
        var chat_Id: String?
        var sourceType :ImageSource
        @Binding var picketType: String
        
        init(images: Binding<[MediaModel]>,  isUploading: Binding<Bool>, type: String, typeKey: String, sourceType: ImageSource, chatId: String, picketType: Binding<String>) {
            self._images = images
            self._isUploading = isUploading
            self.type = type
            self.typeKey = typeKey
            self.sourceType = sourceType
            self.chat_Id = chatId
            self._picketType = picketType
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            for result in results {
                
                let itemProvider = result.itemProvider
                
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        self?.picketType = "image"
                        DispatchQueue.main.async {
                            guard let safeImage = image as? UIImage else {
                                print("** wk image error: \(error)")
                                return
                            }
                            
                            if(self?.type == "chat") {
                                self?.uploadMedia(media: safeImage, type:  "CHAT_IMAGES_URL", chatId: self?.chat_Id)
                            }
                            else if(self?.type=="profile") {
                                self?.uploadMedia(media: safeImage, type:  "USER_PROFILE_URL", chatId: self?.chat_Id)
                            }
                            else {
                                print("image type is", self?.typeKey)
                                self?.uploadMedia(media: safeImage, type: self?.typeKey ?? "PROPERTY_IMAGES_URL", chatId: nil)
                            }
                            
                        }
                    }
                } else {
                    itemProvider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
                        if let videoURL = url {
                            self.picketType = "video"
                            self.uploadMedia(media: videoURL, type: "CHAT_IMAGES_URL", chatId: self.chat_Id)
                        }
                        
                    }
                }
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
                if mediaType == "public.image" {
                    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                        DispatchQueue.main.async { [self] in
                            if(self.type == "chat") {
                                uploadMedia(media: image, type: "CHAT_IMAGES_URL", chatId: self.chat_Id)
                            }
                            else if(self.type=="profile") {
                                uploadMedia(media: image, type: "USER_PROFILE_URL", chatId: self.chat_Id)
                            } else {
                                print("image type is", self.typeKey)
                                uploadMedia(media: image, type: self.typeKey ?? "PROPERTY_IMAGES_URL" , chatId: nil)
                            }
                        }
                    }
                } else if mediaType == "public.movie" {
                    if let videoURL = info[.mediaURL] as? URL {
                        DispatchQueue.main.async {
                            self.picketType = "video"
                            self.uploadMedia(media: videoURL, type: "CHAT_IMAGES_URL", chatId: self.chat_Id)
                        }
                    }
                }
            }
            picker.dismiss(animated: true)
        }
        
        
        
        func uploadMedia(media: Any, type: String, chatId: String?) {
            print(type, chatId)
            DispatchQueue.main.async {
                if((type == "PROPERTY_IMAGES_URL") || (type == "VEHICLE_IMAGES_URL")) {
                    self.isUploading = true
                }
                
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
            
            var body = Data()
            
            if let image = media as? UIImage {
                guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                    return
                }
                
                // Add image data
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            } else  if let videoURL = media as? URL {
                do {
                    let videoData = try Data(contentsOf: videoURL)
                    
                    print("Video URL is", videoURL)
                    // Add video data
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"file\"; filename=\"video.mov\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: video/mp4\r\n\r\n".data(using: .utf8)!)
                    body.append(videoData)
                    body.append("\r\n".data(using: .utf8)!)
                } catch {
                    print("Error converting video to data: \(error)")
                    return
                }
            }
            
            // Add type data
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"type\"\r\n\r\n".data(using: .utf8)!)
            body.append(type.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
            
            // Add chat_id data if available
            if let chatId = chatId {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"chat_id\"\r\n\r\n".data(using: .utf8)!)
                body.append(chatId.data(using: .utf8)!)
                body.append("\r\n".data(using: .utf8)!)
            }
            
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            // Print request body and URL
            print("Request URL:", request.url?.absoluteString ?? "No URL")
            if let requestBody = String(data: body, encoding: .utf8) {
                print("Request Body:", requestBody)
            } else {
                print("Request Body: Unable to decode body data")
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error uploading media: \(error)")
                    // Handle the error (e.g., show an alert to the user)
                    return
                }
                
                guard let data = data else {
                    print("No data received from the server")
                    // Handle the absence of data (e.g., show an alert to the user)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let fileName = json["file_name"] as? String {
                            // Now you can use the fileName as needed
                            DispatchQueue.main.async {
                                
                                if type == "USER_PROFILE_URL" {
                                    self.images.removeAll()
                                    if let image = media as? UIImage {
                                        self.images.append(MediaModel(image: image, fileName: fileName))
                                    }
                                } else if type == "CHAT_IMAGES_URL" {
                                    self.images.removeAll()
                                    if let image = media as? UIImage {
                                        print("urlll" , json["url"])
                                        self.images.append(MediaModel(image: image, fileName: fileName, url: json["url"] as? String ?? ""))
                                    } else if let videoURL = media as? URL {
                                        print("urlll" , json["url"])
                                        self.images.append(MediaModel(videoURL: videoURL, fileName: fileName, url: json["url"] as? String ?? ""))
                                    }
                                } else {
                                    if let image = media as? UIImage {
                                        self.isUploading = false
                                        self.images.append(MediaModel(image: image, fileName: fileName))
                                        
                                    }
                                }
                            }
                        } else {
                            print("Missing 'file_name' in the JSON response")
                            // Handle the absence of 'file_name' (e.g., show an alert to the user)
                        }
                    } else {
                        print("Failed to parse JSON response")
                        // Handle the failure to parse JSON (e.g., show an alert to the user)
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                    // Handle the error (e.g., show an alert to the user)
                }
            }
            
            task.resume()
        }
    }
}
