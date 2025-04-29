//
//  Extension_View.swift
//  Kulushae
//
//  Created by ios on 12/10/2023.
//

import Foundation

import SwiftUI
import SwiftUIGenericDialog
import SDWebImageSwiftUI
import SDWebImage

public struct DateTimePickerDialog: View {
    @Binding public var isShowing: Bool
    @Binding public var selection: Date
    public let range: ClosedRange<Date>
    public let components: DatePickerComponents
    public let style: Style
    public let backgroundColor: Color?
    public let foregroundColor: Color?
    public let buttons: [DateTimePickerDialog.Button]
    @ViewBuilder public let label: (() -> Text)?
    
    // this allows for cancellation to happen - any change in the DatePicker is
    // reflected in `internalSelection` and is only applied to `selection` when
    // `confirm` is called
    private var internalSelection: State<Date>
    
    init(isShowing: Binding<Bool>,
         selection: Binding<Date>,
         range: ClosedRange<Date>,
         components: DatePickerComponents,
         style: Style,
         backgroundColor: Color?,
         foregroundColor: Color?,
         buttons: [DateTimePickerDialog.Button],
         label: (() -> Text)?) {
        _isShowing = isShowing
        _selection = selection
        self.range = range
        self.components = components
        self.style = style
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.buttons = buttons
        self.label = label
        internalSelection = State(initialValue: selection.wrappedValue)
    }
    
    public var body: some View {
        VStack {
            if label != nil {
                label!()
                    .foregroundColor(foregroundColor ?? .black)
                    .padding(.bottom, 10)
            }
            datePicker
            HStack {
                ForEach(buttons) { button in
                    button
                        .swiftUIButton(in: self)
                        .frame(minWidth: 0, maxWidth: .infinity) // evenly space buttons
                }
            }.frame(minWidth: 0, maxWidth: .infinity) // fill entire width of the dialog
                .padding(.top, 10)
        }
        .padding()
        .background(backgroundColor ?? .white)
    }
    
    private var datePicker: some View {
        let dp = DatePicker(selection: internalSelection.projectedValue,
                            in: range,
                            displayedComponents: components) {
            EmptyView()
        }.labelsHidden()
        
        var view: AnyView = AnyView(dp.datePickerStyle(DefaultDatePickerStyle()))
        if style == .wheel {
            view = AnyView(dp.datePickerStyle(WheelDatePickerStyle()))
        } else if #available(iOS 14.0, *) {
            if style == .compact {
                view = AnyView(dp.datePickerStyle(CompactDatePickerStyle()))
            } else if style == .graphical {
                view = AnyView(dp.datePickerStyle(GraphicalDatePickerStyle()))
            }
        }
        
        if let color = foregroundColor {
            if #available(iOS 14.0, *),
               style == .compact || style == .default {
                view = AnyView(view.accentColor(color))
            } else {
                view = AnyView(view
                    .colorInvert()
                    .colorMultiply(color))
            }
        }
        
        return view
    }
    
    public func confirm() {
        selection = internalSelection.wrappedValue
        isShowing = false
    }
    
    public func cancel() {
        isShowing = false
    }
    
    public static var defaultButtons: [DateTimePickerDialog.Button] {
        [.default(label: "OK", action: { dialog in
            dialog.confirm()
        }),
         .cancel(label: "Cancel", action: { dialog in
             dialog.cancel()
         })]
    }
    
    public enum Style {
        case `default`, wheel
        
        @available(iOS 14.0, *)
        case compact, graphical
    }
    
    public struct Button: Identifiable {
        public let id = UUID()
        let label: () -> Text
        let action: (DateTimePickerDialog) -> Void
        
        func swiftUIButton(in dialog: DateTimePickerDialog) -> SwiftUI.Button<Text> {
            SwiftUI.Button(action: { action(dialog) },
                           label: { label()
                    .foregroundColor(dialog.foregroundColor ?? .blue)
            })
        }
        
        public static func `default`(label: String,
                                     action: ((DateTimePickerDialog) -> Void)? = nil) -> Button {
            Button(label: { Text(label)
                .fontWeight(.bold) },
                   action: action ?? { $0.confirm() })
        }
        
        public static func cancel(label: String,
                                  action: ((DateTimePickerDialog) -> Void)? = nil) -> Button {
            Button(label: { Text(label) },
                   action: action ?? { $0.cancel() })
        }
        
        public static func custom(label: @escaping () -> Text,
                                  action: @escaping (DateTimePickerDialog) -> Void) -> Button {
            Button(label: label, action: action)
        }
    }
}

extension View {
    
    func dateTimePickerDialog(isShowing: Binding<Bool>,
                              cancelOnTapOutside: Bool = false,
                              selection: Binding<Date>,
                              in range: ClosedRange<Date> = .distantPast ... .distantFuture,
                              displayComponents components: DatePickerComponents = [.hourAndMinute, .date],
                              style: DateTimePickerDialog.Style = .default,
                              backgroundColor: Color? = nil,
                              foregroundColor: Color? = nil,
                              buttons: [DateTimePickerDialog.Button] = DateTimePickerDialog.defaultButtons,
                              label: (() -> Text)? = nil) -> some View {
        let dialog = DateTimePickerDialog(isShowing: isShowing,
                                          selection: selection,
                                          range: range,
                                          components: components,
                                          style: style,
                                          backgroundColor: backgroundColor,
                                          foregroundColor: foregroundColor,
                                          buttons: buttons,
                                          label: label)
        
        return self.genericDialog(isShowing: isShowing,
                                  cancelOnTapOutside: cancelOnTapOutside,
                                  cancelAction: { dialog.cancel() }) {
            dialog.cornerRadius(10, corners: [.allCorners])
                .frame(width: .screenWidth * 0.85)
                
        }
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


extension View {
    func cachedWebImage(urlString: String) -> some View {
        WebImage(url: URL(string: urlString))
            .resizable()

            .onSuccess { image, data, cacheType in
                // Handle success if needed
            }
            .indicator(.activity) // Activity indicator while loading
            .transition(.fade(duration: 0.5)) // Fade transition
            .aspectRatio(contentMode: .fill) // Fit within the parent view's frame
    }
}
