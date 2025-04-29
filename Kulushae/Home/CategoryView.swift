import SwiftUI
import SDWebImageSwiftUI

struct CategoryView: View {
    
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
    var onCategorySelected: (String,String) -> Void // Callback to handle selection

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    categoryView(for: category)
                }
            }
            .padding(.horizontal, 10)
        }
    }
//background: radial-gradient(50% 50% at 50% 50%, #BDBFDC 0%, #CDE1EF 100%);

    private func categoryView(for category: CategoryListModel) -> some View {

        
        let isSelected = selectedCategory == category.id
        let gbColor = category.bgColor ?? "#BDBFDC"
        let backgroundColor = Color(hex:gbColor) // Background color
        let borderColor = isSelected ? backgroundColor : Color.clear // Change border color based on selection

        return VStack {
            if !hideImage {
                imageBackground(for: category)
                    .padding(.top, 5) // Padding for the image
            }
            categoryTitle(for: category)
                .padding(.top, 5) // Padding above the title
                .padding(.bottom, 5) // Padding below the title
        }
        .frame(width: 94, height: 94) // Set fixed size for the category view
        .background(isSelected ? backgroundColor.opacity(0.5) : backgroundColor)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(borderColor, lineWidth: 2) // Set border color
        )
        .onTapGesture {
            handleCategoryTap(for: category)
        }
    }

    private func imageBackground(for category: CategoryListModel) -> some View {
        cachedWebImage(urlString: Config.imageBaseUrl + (category.image ?? ""))
            .scaledToFit()
            .frame(width: 65, height: 65) // Fixed size for the image
            .padding(.top,10)
            
            // Center the image in the VStack
    }

    private func categoryTitle(for category: CategoryListModel) -> some View {
        Text(LocalizedStringKey(category.title ?? ""))
            .font(.system(size: 12)) // Font size for title
            .foregroundColor(Color.black)
            .multilineTextAlignment(.center)
            .lineLimit(2) // Allow up to 2 lines for the title
            .minimumScaleFactor(0.8) // Allow text to scale down if necessary
            .frame(maxWidth: .infinity) // Center the text
            .padding(.bottom, 5)
            .padding(.leading, 5)
            .padding(.trailing, 5)
            .padding(.top, -20)
    }

    private func handleCategoryTap(for category: CategoryListModel) {
        selectedCategory = category.id
        onCategorySelected(category.id,category.service_type ?? "") // Invoke the callback based on type
        
            // Handle main category specific actions
//            if (category.service_type ?? "").lowercased().contains("motor") {
//                isMotorOpen = true
//                isOpen = false
//            } else {
                isOpen = true
                isMotorOpen = false
//            }
        }
    
}

// Extension to handle hex color conversion
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.hasPrefix("#") ? hex.index(after: hex.startIndex) : hex.startIndex

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

