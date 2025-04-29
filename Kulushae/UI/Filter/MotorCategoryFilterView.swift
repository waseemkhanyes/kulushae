//
//  MotorCategoryFilterView.swift
//  Kulushae
//
//  Created by Waseem  on 01/01/2025.
//

import SwiftUI

enum FilterOptonType: String {
    case DropDown = "dropdown"
    case Slider = "slider"
    case CheckBox = "checkbox"
    case Range = "range"
}

struct MotorCategoryFilterView: View {
    @StateObject var viewModel = MotorCategoryFilterViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(spacing: 0) {
            topView
            
            listOptionsView
                .padding(.vertical, 20)
            
            
            Spacer()
            
            AppButton(titleVal: "Apply", isSelected: .constant(true))
                .onTapGesture {
                    viewModel.onClickApply()
//                    dataHandler.isCarLoading = true
//                    self.submitFilter()
                }
        }
        .fullScreenCover(isPresented: $viewModel.presentDrowDown) {
            FilterDropDownOptionsPopup(viewModel: .init(data: viewModel.dicSelectedDropwDown) { selected in
                viewModel.presentDrowDown = false
                if let data = selected {
                    var fieldName = ""
                    var arrayData = viewModel.arrayFilterOptions.map({ item in
                        var item = item
                        if item["id"].intValue == viewModel.dicSelectedDropwDown["id"].intValue {
                            fieldName = item["field_name"].stringValue
                            item["selection"] = JSON(data)
                        }
                        return item
                    })
                    
                    if fieldName == "motor_makes" {
                        arrayData = arrayData.map({ item in
                            var item = item
                            if item["field_name"].stringValue == "model_id" {
                                item["selection"] = JSON([:])
                                item["motor_makes_selection"] = JSON(data)
                            }
                            return item
                        })
                    }
                    
                    viewModel.arrayFilterOptions = arrayData
                }
            })
            .clearBackground()
        }
    }
    
    
    var topView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button(action: viewModel.onClickCross) {
                    VStack(spacing: 0) {
                        Image(.close)
                            .renderingMode(.template)
                            .foregroundStyle(.black)
                    }
                    .frame(width: 40, height: 40)
                }
                .padding(.leading, 10)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text(LocalizedStringKey("Filters"))
                        .font(.Roboto.Bold(of: 22))
                        .foregroundStyle(.black)
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                }
                
                Spacer()
                
                Button(action: viewModel.onClickReset) {
                    VStack(spacing: 0) {
                        Text(LocalizedStringKey("Reset"))
                            .foregroundStyle(.red)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    }
                    .frame(height: 40)
                }
                .padding(.trailing, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Divider()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .background(.black.opacity(0.3))
                
        }
        .frame(height: 60)
    }
    
    var listOptionsView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                ForEach($viewModel.arrayFilterOptions.indices, id: \.self) { index in
                    let item = $viewModel.arrayFilterOptions[index]
                    let data = item.wrappedValue
                    if let type = FilterOptonType(rawValue: item.wrappedValue["type"].stringValue) {
                        
                        if type == .DropDown {
                            FilterDropDownItemView(data: data) {
                                viewModel.dicSelectedDropwDown = data
                                viewModel.presentDrowDown = true
                            }
                        } else if type == .Slider {
                            FilterSliderItemView(data: $viewModel.arrayFilterOptions[index]) {
                                
                            }
                        } else if type == .CheckBox {
                            FilterCheckBoxItemView(data: item)
                        } else if type == .Range {
                            FilterRangeItemView(
                                priceSlider: .init(
                                    start: data["extras"]["min"].doubleValue,
                                    end: data["extras"]["max"].doubleValue
                                ),
                                data: item,
                                lowValueText: data["selection"]["min"].stringValue,
                                upperValueText: data["selection"]["max"].stringValue
                            )
                        }
                    } else {
                        EmptyView()
                    }
                    
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    MotorCategoryFilterView()
}
