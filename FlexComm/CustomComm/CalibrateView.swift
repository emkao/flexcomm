//
//  CalibrateView.swift
//  CustomComm
//
//  Created by emily kao on 4/14/21.
//

import SwiftUI

struct CalibrateView: View {
    @EnvironmentObject var bleController: BLEController
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack {
            Button(action: { // back button
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.backward")
            })
            .padding(30)
            Spacer()
        }
        VStack {
            Text("Flex Flex sensor to desired threshold for 'Yes'")
            Button(action: {
                bleController.calibrateFlexSensor()
            }, label: {
                Text("Set Flex Sensor Threshold")
            })
            
        }
    }
}
