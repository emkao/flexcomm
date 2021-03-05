//
//  CustomFont.swift
//  FlexComm
//
//  Created by emily kao on 2/24/21.
//

import Foundation
import SwiftUI

struct CustomFont: ViewModifier {
    var style: UIFont.TextStyle = .body
    var weight: Font.Weight = .regular
    
//    var textColor: Color {
//        switch style {
//        case .title1:
//            return .blue
//        case .caption1:
//            return Color.black.opacity(0.8)
//        default:
//            return .black
//        }
//    }

    func body(content: Content) -> some View {
        content
            .font(Font.custom("SFProText-Thin", size: UIFont.preferredFont(forTextStyle: style).pointSize)
            .weight(weight))
            .foregroundColor(.black)
    }
}

extension View {
    func SFProFont(style: UIFont.TextStyle, weight: Font.Weight) -> some View {
        self.modifier(CustomFont(style: style, weight: weight))
    }
}
