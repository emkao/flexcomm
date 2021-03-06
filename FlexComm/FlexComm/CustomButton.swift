//
//  CustomButton.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import Foundation
import SwiftUI

struct CustomButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(.black)
            .frame(width: 250, height: 250, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.black, lineWidth: 5)
            )
            .padding(20)
            .background(Color.white)
    }
}
