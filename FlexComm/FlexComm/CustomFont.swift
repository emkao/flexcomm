//
//  CustomFont.swift
//  FlexComm
//
//  Created by emily kao on 2/24/21.
//

import Foundation
import SwiftUI

//struct CustomFont: ViewModifier {
//    var style: UIFont.TextStyle = .body
//    var weight: Font.Weight = .regular
//
//    func body(content: Content) -> some View {
//        content
//            .font(Font.custom("SFProText-Thin", size: UIFont.preferredFont(forTextStyle: style).pointSize)
//            .weight(weight))
//            .foregroundColor(.black)
//    }
//}

struct CustomFont: ViewModifier {
    @EnvironmentObject var globals: GlobalVars
    
    //only change here is that size went up  x2
    var style: UIFont.TextStyle = .body
    var weight: Font.Weight = .regular

    func body(content: Content) -> some View {
        content
            .font(Font.custom("SFProText-Light", size: UIFont.preferredFont(forTextStyle: style).pointSize * CGFloat(self.globals.multiplier))
            .weight(weight))
            .foregroundColor(.black)
    }
}


extension View {
    func SFProFont(style: UIFont.TextStyle, weight: Font.Weight) -> some View {

        self.modifier(CustomFont(style: style, weight: weight))
    }
//    func SFProFontSmall(style: UIFont.TextStyle, weight: Font.Weight) -> some View {
//        self.modifier(CustomFont(style: style, weight: weight))
    //}
//    func SFProFontBig(style: UIFont.TextStyle, weight: Font.Weight) -> some View {
//        self.modifier(CustomFontBig(style: style, weight: weight))
//    }
//
//    func SFProFont2(style: UIFont.TextStyle, weight: Font.Weight) -> some View {
//        if(GlobalVars.bigFontOn){
//            return AnyView(SFProFontBig(style: style, weight: weight))
//            //return self.modifier(CustomFontBig(style: style, weight: weight))
//
//        }
//        else{
//            return AnyView(SFProFontSmall(style: style, weight: weight))
//
//        }
//    }
    
}
