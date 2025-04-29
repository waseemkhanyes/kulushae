//
//  ExtensionAppLevel.swift
//  Kulushae
//
//  Created by Waseem  on 11/11/2024.
//

import Foundation
import SwiftUI

func onMain(run :() -> ())
{
    if Thread.isMainThread {
        run()
    } else {
        DispatchQueue.main.sync(execute: run)
    }
}

func onBackGround(afterDelay:Double = 0.0, run :@escaping () -> ())
{
    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + afterDelay, execute: run)
}

extension View {
    
    @ViewBuilder func isRemove(remove: Bool = false) -> some View {
            if !remove {
                self
            }
    }
    
    func popUpBack(show: Bool = false) -> some View {
        overlay(
            
            Color(hex: 0x000000, alpha: 0.2)
                .ignoresSafeArea()
                .isRemove(remove: !show)
                .transition(.opacity)
                .animation(.linear(duration: 0.3))
        )
    }
}

extension Font {
//    =============================
//    Family: Roboto
//    =============================
//    Roboto-Regular
//    Roboto-Italic
//    Roboto-Thin
//    Roboto-ThinItalic
//    Roboto-Light
//    Roboto-LightItalic
//    Roboto-Medium
//    Roboto-MediumItalic
//    Roboto-Bold
//    Roboto-BoldItalic
//    Roboto-Black
//    Roboto-BlackItalic
    
    enum Roboto {
        
        static func Regular(of size:CGFloat) -> Font { return Font.custom( "Roboto-Regular", size: size) }
        static func Italic(of size:CGFloat) -> Font { return Font.custom( "Roboto-Italic", size: size) }
        static func Thin(of size:CGFloat) -> Font { return Font.custom( "Roboto-Thin", size: size) }
        static func ThinItalic(of size:CGFloat) -> Font { return Font.custom( "Roboto-ThinItalic", size: size) }
        static func Light(of size:CGFloat) -> Font { return Font.custom( "Roboto-Light", size: size) }
        static func LightItalic(of size:CGFloat) -> Font { return Font.custom( "Roboto-LightItalic", size: size) }
        static func Medium(of size:CGFloat) -> Font { return Font.custom( "Roboto-Medium", size: size) }
        static func MediumItalic(of size:CGFloat) -> Font { return Font.custom( "Roboto-MediumItalic", size: size) }
        static func Bold(of size:CGFloat) -> Font { return Font.custom( "Roboto-Bold", size: size) }
        static func BoldItalic(of size:CGFloat) -> Font { return Font.custom( "Roboto-BoldItalic", size: size) }
        static func Black(of size:CGFloat) -> Font { return Font.custom( "Roboto-Black", size: size) }
        static func BlackItalic(of size:CGFloat) -> Font { return Font.custom( "Roboto-BlackItalic", size: size) }
    }
}

