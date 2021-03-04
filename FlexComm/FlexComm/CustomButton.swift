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
            .padding()
            .background(Color.white)
            .border(Color.black, width: 2)
            .cornerRadius(8)
    }
}
