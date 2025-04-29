//
//  FilterSliderItemView.swift
//  Kulushae
//
//  Created by Waseem  on 01/01/2025.
//

import SwiftUI

struct FilterSliderItemView: View {
    @Binding var data: JSON
    
    var handler: (()->())? = nil
    
    var title: String {
        data["title"].stringValue
    }
    
    var isMultiple: Bool {
        data["multiple"].boolValue
    }
    var arrayOptions: [JSON] {
        data["values"].arrayValue
    }
    var selected: JSON {
        data["selection"]
    }
    var arraySelected: [JSON] {
        data["selection"].arrayValue
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleView
            
            sliderListView
        }
        .frame(maxWidth: .infinity)
    }
    
    var titleView: some View {
        Text(title)
            .font(.Roboto.Bold(of: 18))
            .foregroundStyle(.black)
            .padding(.bottom, 10)
    }
    
    var sliderListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(arrayOptions, id: \.self.dictionaryValue["value"]?.stringValue) { item in
                    sliderItemView(data: item, isSelected: checkIsSelected(item: item))
                }
            }
        }
    }
    
    func sliderItemView(data: JSON, isSelected: Bool) -> some View {
        Button(action: {
            if isMultiple {
                var arraySelection = arraySelected
                if arraySelection.remove(data) == nil {
                    arraySelection.append(data)
                }

                self.data["selection"] = JSON(arraySelection)
            } else {
                self.data["selection"] = data
            }
        }) {
            Text(data["text"].stringValue)
                .foregroundStyle(Color.black.opacity(isSelected ? 1.0 : 0.54))
                .font(isSelected ? .Roboto.Medium(of: 16) : .Roboto.Regular(of: 16))
                .padding(.vertical, 5)
                .padding(.horizontal, 8)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black.opacity(isSelected ? 1.0 : 0.54), lineWidth: isSelected ? 1.5 : 1)
                }
                .padding(1)
        }
    }
    
    func checkIsSelected(item: JSON) -> Bool {
        if isMultiple {
          return arraySelected.filter({$0["value"].stringValue == item["value"].stringValue}).count > 0
        } else {
            return item["value"].stringValue == selected["value"].stringValue
        }
    }
}

#Preview {
    FilterSliderItemView(data: .constant(JSON([:])))
}
