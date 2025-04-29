import SwiftUI
import SDWebImageSwiftUI


struct SubCategoryView: View {
    
    enum SelectionType {
        case mainCategory
        case subCategory
    }
    
    @Binding var categories: [CategoryListModel]
    @Binding var selectedCategory: String
    @Binding var isOpen: Bool
    @Binding var isMotorOpen: Bool
    @EnvironmentObject var languageManager: LanguageManager
    let hideImage: Bool
    var onCategorySelected: (String) -> Void // Callback to handle selection

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10.0) {
                ForEach(categories, id: \.self) { category in
                    VStack {
                        if !hideImage {
                            ZStack {
                                cachedWebImage(urlString: Config.imageBaseUrl + (category.image ?? ""))
                                    .transition(.opacity)
                                    .animation(.easeInOut(duration: 0.25), value: hideImage)
                            }
                            .frame(width: 72, height: 72)
                            .background(selectedCategory == category.id ? Color.backgroundCategoryColor.opacity(0.5) : Color.backgroundCategoryColor)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(selectedCategory == category.id ? Color.backgroundCategoryColor.opacity(1.0) : Color.clear, lineWidth: 2)
                            )
                        }
                        Text(LocalizedStringKey(category.title ?? ""))
                            .font(.roboto_16_bold())
                            .fontWeight(.bold)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.black)
                    }
                    .onTapGesture {
                        // Set selected category
                        selectedCategory = category.id
                        onCategorySelected(category.id) // Invoke the callback based on type
                        if (category.service_type ?? "").lowercased().contains("motor") {
                            isMotorOpen = true
                            isOpen = false
                        } else {
                            isOpen = true
                            isMotorOpen = false
                        }
                    }
                }
            }
        }
    }
}

