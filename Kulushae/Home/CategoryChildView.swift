import SwiftUI

struct CategoryChildView: View {
    @State  var internalCatId: Int? // Use this for internal state
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var categories: [CategoryListModel]
    
    // Callback to notify the parent when catId changes
    var onCatIdChanged: (Int?, Bool, String) -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(categories, id: \.self) { category in
                HStack {
                    Text(LocalizedStringKey(category.title ?? ""))
                        .font(.roboto_16())
                        .fontWeight(.medium)
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                        .onTapGesture {
                            if !(category.has_child ?? false ){
                                DispatchQueue.main.async {
                                    self.internalCatId = Int(category.id)  ?? -1 // Update the internal state
                                    print("chosen catid", internalCatId, category.title ?? "")
                                    if(category.has_form) {
//                                        AdDetailsView.parentCatIdVal = Int(category.id)  ?? -4
                                    }
                                    onCatIdChanged(internalCatId, false, category.title ?? "")
                                }
                                
                            } else {
                                DispatchQueue.main.async {
                                    self.internalCatId = Int(category.id)  ?? -1// Update the internal state
                                    print("chosen catid", internalCatId)
                                    if(category.has_form) {
//                                        AdDetailsView.parentCatIdVal = Int(category.id)  ?? -1
                                    }
                                    onCatIdChanged(internalCatId, true, category.title ?? "")
                                }
                                
                            }
                            
                        }
                    Spacer()
                    if category.has_child ?? false {
                        ZStack{
                            Image("arrow_forword")
                                .frame(width: 22, height: 22)
                                .scaleEffect(languageManager.currentLanguage == "ar" ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
                        }
                        .frame(width: 35, height: 35)
                        
                        .onTapGesture {
                            if !(category.has_child ?? false ){
                                DispatchQueue.main.async {
                                    self.internalCatId = Int(category.id)  ?? -1 // Update the internal state
                                    print("chosen catid", internalCatId, category.title ?? "")
                                    if(category.has_form) {
//                                        AdDetailsView.parentCatIdVal = Int(category.id)  ?? -4
                                    }
                                    onCatIdChanged(internalCatId, false, category.title ?? "")
                                }
                                
                            } else {
                                DispatchQueue.main.async {
                                    self.internalCatId = Int(category.id)  ?? -1// Update the internal state
                                    print("chosen catid", internalCatId)
                                    if(category.has_form) {
//                                        AdDetailsView.parentCatIdVal = Int(category.id)  ?? -1
                                    }
                                    onCatIdChanged(internalCatId, true, category.title ?? "")
                                }
                                
                            }
                            
                        }
                    }
                }
                .padding(.bottom, 15)
            }
        }
    }
}
