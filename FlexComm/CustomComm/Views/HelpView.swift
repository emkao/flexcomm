//
//  HelpView.swift
//  CustomComm
//
//  Created by emily kao on 4/18/21.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Help")
                    .font(.custom("SFProText-Thin", size: 50))
                    .padding(30)
//                Spacer()
                VStack(alignment: .leading) {
                    Text("Starting out:")
                        .font(.custom("SFProText", size: 30))
                        .padding(30)
                    Text("Our application works with a Bluetooth Arduino and flex sensor. First, connect your sensor by going into Settings and pressing \"Scan\".")
                        .font(.custom("SFProText-Thin", size: 30))
                    Text("After calibrating the sensor, press \"Start\" on the home page to enter Options View. The blue selection will then begin to rotate through the options on the screen. ")
                        .font(.custom("SFProText-Thin", size: 30))
                    Text("How to Use the Flex Sensor:")
                        .font(.custom("SFProText", size: 30))
                        .padding(30)
                    Text("1 flex of the flex sensor will select the current option")
                        .font(.custom("SFProText-Thin", size: 30))
                    Text("2 quick flexs will go back to the previous screen(equivalent to pressing \"Back\")." )
                        .font(.custom("SFProText-Thin", size: 30))
                    Text("3 quick flexs will play the help noise(equivalent to pressing \"Help\")")
                        .font(.custom("SFProText-Thin", size: 30))
                    Text("The flex sensor will only be used in the app after pressing \"Start\" and entering Options View. Additionally, if one wants to mimic moving the flex sensor through touch, press \"Moved Flex Sensor\". ")
                        .font(.custom("SFProText-Thin", size: 30))
                }
//                font(.custom("SFProText-Thin", size: 30))
                Spacer()
            }

            .edgesIgnoringSafeArea(.top)
            Spacer()
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
