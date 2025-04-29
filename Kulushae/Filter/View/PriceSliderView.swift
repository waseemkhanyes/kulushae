//
//  PriceSliderView.swift
//  Kulushae
//
//  Created by ios on 09/02/2024.
//
import SwiftUI
import Combine

//SliderValue to restrict double range: 0.0 to 1.0
@propertyWrapper
struct SliderValue {
    var value: Double
    
    init(wrappedValue: Double) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Double {
        get { value }
        set { value = min(max(0.0, newValue), 1.0) }
    }
}

class SliderHandle: ObservableObject {
    
    //Slider Size
    let sliderWidth: CGFloat
    let sliderHeight: CGFloat
    
    //Slider Range
    let sliderValueStart: Double
    let sliderValueRange: Double
    
    //Slider Handle
    var diameter: CGFloat = 20
    var startLocation: CGPoint
    
    //Current Value
    @Published var currentPercentage: SliderValue
    
    //Slider Button Location
    @Published var onDrag: Bool
    @Published var currentLocation: CGPoint
    @EnvironmentObject var languageManager: LanguageManager
    weak var customSlider: CustomSlider?
    
    init(sliderWidth: CGFloat, sliderHeight: CGFloat, sliderValueStart: Double, sliderValueEnd: Double, startPercentage: SliderValue) {
        self.sliderWidth = sliderWidth
        self.sliderHeight = sliderHeight
        
        self.sliderValueStart = sliderValueStart
        self.sliderValueRange = sliderValueEnd - sliderValueStart
        
        let startLocation = CGPoint(x: (CGFloat(startPercentage.wrappedValue)/1.0)*sliderWidth, y: sliderHeight/2)
        
        self.startLocation = startLocation
        self.currentLocation = startLocation
        self.currentPercentage = startPercentage
        
        self.onDrag = false
    }
    lazy var sliderDragGesture: _EndedGesture<_ChangedGesture<DragGesture>> = DragGesture()
        .onChanged { value in
            self.onDrag = true
            
            let dragLocation = value.location
            
            // Calculate new position within the valid range of the slider width
            var newX = min(max(dragLocation.x, 0), self.sliderWidth)
            if UserDefaults.standard.string(forKey: "AppLanguage") ?? "en" == "ar" {
                newX = min(max(self.sliderWidth - dragLocation.x, 0), self.sliderWidth)
            }
            // Ensure lower handle doesn't exceed higher handle
            if self === self.customSlider?.lowHandle && newX > self.customSlider?.highHandle.currentLocation.x ?? 0.0 {
                return
            }
            if self === self.customSlider?.highHandle && newX < self.customSlider?.lowHandle.currentLocation.x ?? 0.0 {
                return // Do not update if violating constraint
            }
            // Update currentLocation
            self.currentLocation = CGPoint(x: newX, y: self.startLocation.y)
            
            // Update current percentage based on the new position
            let percentage = Double(newX / self.sliderWidth)
            self.currentPercentage.wrappedValue = min(max(0, percentage), 1)
            
        }.onEnded { _ in
            self.onDrag = false
        }
    private func restrictSliderBtnLocation(_ dragLocation: CGPoint) {
        //On Slider Width
        if dragLocation.x > 0 && dragLocation.x < sliderWidth {
            calcSliderBtnLocation(dragLocation)
        }
    }
    
    private func calcSliderBtnLocation(_ dragLocation: CGPoint) {
        // Calculate new x-coordinate based on drag location
        let newX = min(max(dragLocation.x, 0), sliderWidth)
        
        // Update currentLocation
        currentLocation = CGPoint(x: newX, y: startLocation.y)
    }
    
    //Current Value
    var currentValue: Double {
        return sliderValueStart + currentPercentage.wrappedValue * sliderValueRange
    }
}

class CustomSlider: ObservableObject {
    
    //Slider Size
    let width: CGFloat = .screenWidth * 0.8
    let lineWidth: CGFloat = 5
    
    //Slider value range from valueStart to valueEnd
    let valueStart: Double
    let valueEnd: Double
    
    //Slider Handle
    @Published var highHandle: SliderHandle
    @Published var lowHandle: SliderHandle
    
    //Handle start percentage (also for starting point)
    @SliderValue var highHandleStartPercentage = 1.0
    @SliderValue var lowHandleStartPercentage = 0.0
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    var anyCancellableHigh: AnyCancellable?
    var anyCancellableLow: AnyCancellable?
    
    init(start: Double, end: Double) {
        valueStart = start
        valueEnd = end
        
        highHandle = SliderHandle(sliderWidth: width ,
                                  sliderHeight: lineWidth,
                                  sliderValueStart: valueStart,
                                  sliderValueEnd: valueEnd,
                                  startPercentage: _highHandleStartPercentage
        )
        
        lowHandle = SliderHandle(sliderWidth: width ,
                                 sliderHeight: lineWidth,
                                 sliderValueStart: valueStart,
                                 sliderValueEnd: valueEnd ,
                                 startPercentage: _lowHandleStartPercentage
        )
        
        anyCancellableHigh = highHandle.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
        anyCancellableLow = lowHandle.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
        highHandle.customSlider = self
        lowHandle.customSlider = self
    }
    
    func updateHandleLocations() {
        let leftHandleLocation = CGPoint(
            x: CGFloat(lowHandle.currentPercentage.wrappedValue) * width,
            y: 5
        )
        let rightHandleLocation = CGPoint(
            x: CGFloat(highHandle.currentPercentage.wrappedValue) * width,
            y: 5
        )
        
        lowHandle.currentLocation = leftHandleLocation
        highHandle.currentLocation = rightHandleLocation
        
    }
    
    func resetSliderValues() {
        lowHandle.currentPercentage.wrappedValue = 0.0
        highHandle.currentPercentage.wrappedValue = 1.0
        
        // Reset the slider handles to their start locations
        lowHandle.currentLocation = lowHandle.startLocation
        highHandle.currentLocation = highHandle.startLocation
    }
}
