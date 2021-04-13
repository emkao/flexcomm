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
            .foregroundColor(.white)
            .frame(width: 250, height: 250, alignment: .center)
            .cornerRadius(50)
            .padding(2)
    }
}
