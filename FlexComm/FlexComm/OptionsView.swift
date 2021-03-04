//
//  OptionsView.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import SwiftUI

struct OptionsView: View {
    @ObservedObject var currentOptions = CurrentOptions()
    private var gridItemLayout = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { // back button
                    print("Go back")
                }) {
                    Text("Menu")
                }
                Spacer()
                Button(action: { // add button
                    print("Add button")
                    currentOptions.addOption()
                }) {
                    Text("Add")
                }
                Spacer()
                Button(action: { // delete button
                    print("Delete button")
                    currentOptions.deleteOption()
                }) {
                    Text("Delete")
                }
                Spacer()
                Button(action: { // settings button
                    print("Go to settings")
                }) {
                    Text("Settings")
                }
            }
            .foregroundColor(.black)
            .padding(10.0)

            Spacer()
            let optionCount = currentOptions.options.count
            VStack {
                Spacer()
                LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 0) {
                    ForEach(0 ..< optionCount - (optionCount % 3), id: \.self) {
                        Button(currentOptions.options[$0 % optionCount]) {}
                            .buttonStyle(CustomButton())
                    }
                }
                if (optionCount % 3 != 0) {
                    Spacer()
                    LazyHStack(spacing: 0) {
                        ForEach(optionCount - (optionCount % 3) ..< optionCount, id: \.self) {
                            Button(currentOptions.options[$0 % optionCount]) {}
                                .buttonStyle(CustomButton())
                        }
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .customFont(name: "SFProText-Thin", style: .largeTitle)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
