//
//  CustomFont.swift
//  FlexComm
//
//  Created by emily kao on 2/24/21.
//

import Foundation
import SwiftUI


struct CustomFont: ViewModifier {
    @EnvironmentObject var globals: GlobalVars
    
    var style: UIFont.TextStyle = .body
    var weight: Font.Weight = .regular
    var multiplier: Double = 1.0

    func body(content: Content) -> some View {
        content
            .font(Font.custom("SFProText-Light", size: UIFont.preferredFont(forTextStyle: style).pointSize * CGFloat(multiplier)) // multiplier controls font size
            .weight(weight))
            .foregroundColor(.black)
    }
}


extension View {
    func SFProFont(style: UIFont.TextStyle, weight: Font.Weight, multiplier: Double) -> some View {

        self.modifier(CustomFont(style: style, weight: weight, multiplier: multiplier))
    }
}
