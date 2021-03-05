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
