//
//  ContentView.swift
//  FlexCommPersonal
//
//  Created by Ankita Satyavarapu on 2/22/21.
//  Copyright © 2021 Ankita Satyavarapu. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var globals: GlobalVars
    @StateObject var globals_Nav = GlobalVars()
    @State private var responseTime = ""
    @State private var sliderValue  = GlobalVars().multiplier
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "SFProText-Thin", size: 50)!]
        sliderValue = GlobalVars_Unifier.multiplier_unifier //reinit the value
    }

    var body: some View {

        NavigationView {
            ZStack{
                Color.white
                VStack{
                    HStack{
                        Text("Color Scheme:")
                            .SFProFont(style: .headline, weight: .bold, multiplier: globals_Nav.multiplier)
                        Button(action: {
                            print("Dark Mode tapped!")
                        }) {
                            Text("Dark Mode")
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                        }
                        Button(action: {
                            print("Light Mode tapped!")
                        }) {
                            Text("Light Mode")
                            .padding()
                            .background(Color(UIColor.lightGray))
                            .foregroundColor(.black)
                            .cornerRadius(40)
                        }
                    }
                    .SFProFont(style: .body, weight: .regular, multiplier: globals_Nav.multiplier)
                    .padding()
                    HStack{
                        Text("Font Size:")
                            .SFProFont(style: .headline, weight: .bold, multiplier: globals_Nav.multiplier)
                        VStack{
                            Slider (value: $sliderValue, in: 1.0...3.5)
                            Text("Example Text Size")
                                .SFProFont(style: .body, weight:.regular, multiplier: sliderValue)
                        }
                        Button(action: {
                            //slider updates the constant and this updates the page
                            //so if user forgets to hit it it's not huge deal
                            print("Update Size")
                            print("new value: ", sliderValue)
                            print("old value: ", GlobalVars_Unifier.multiplier_unifier)
                            globals_Nav.multiplier = sliderValue
                            GlobalVars_Unifier.multiplier_unifier = sliderValue
                        }) {
                            Text("Update Size")
                            .padding()
                            .SFProFont(style: .body, weight: .bold, multiplier: globals_Nav.multiplier)
                            .background(Color(UIColor.lightGray))
                            .foregroundColor(.black)
                            .cornerRadius(40)
                        }
                    }
                    HStack{
                        Text("Response Time:")
                            .SFProFont(style: .headline, weight: .bold, multiplier: globals_Nav.multiplier)
                        TextField("Number of Seconds", text: $responseTime)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Seconds")

                    }
                    .SFProFont(style: .body, weight: .regular, multiplier: globals_Nav.multiplier)
                    .environmentObject(globals_Nav)

                }
            }
   
            .navigationBarTitle(Text("Settings"), displayMode: .large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(globals_Nav)
        
        .onAppear(perform: {
            sliderValue = GlobalVars_Unifier.multiplier_unifier
        })
    
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(GlobalVars())
    }
}
