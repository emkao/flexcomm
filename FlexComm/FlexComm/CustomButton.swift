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
            .border(Color.black, width: 2)
            .padding(20)
            .background(Color.white)
            .cornerRadius(12)
    }
}
