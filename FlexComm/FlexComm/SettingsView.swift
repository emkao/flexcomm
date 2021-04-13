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
    @ObservedObject var bleController = BLEController()
    @StateObject var globals_Nav = GlobalVars()
    @State private var responseTime = ""
    @State private var sliderValue  = GlobalVars().multiplier
    @State private var textToSpeech = false
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "SFProText-Thin", size: 50)!]
        sliderValue = GlobalVars_Unifier.multiplier_unifier //reinit the value
    }

    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 40) {
                Text("Settings")
                    .font(.custom("SFProText-Thin", size: 50))
                Group {
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
                }
                Group {
                    HStack{
                        Text("Font Size:")
                            .SFProFont(style: .headline, weight: .bold, multiplier: globals_Nav.multiplier)
                        VStack{
                            Slider (value: $sliderValue, in: 1.0...1.97)
                            Text("Example Text Size")
                                .SFProFont(style: .body, weight:.regular, multiplier: sliderValue)
                        }
                        Button(action: {
                            //slider updates the constant and this updates the page
                            //so if user forgets to hit it it's not huge deal
//                            print("Update Size")
//                            print("new value: ", sliderValue)
//                            print("old value: ", GlobalVars_Unifier.multiplier_unifier)
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
                    .padding(.trailing, 30)
                    .padding(.leading, 30)
                }
                HStack{
                    Text("Response Time:")
                        .SFProFont(style: .headline, weight: .bold, multiplier: globals_Nav.multiplier)
                    TextField("Number of Seconds", text: $responseTime)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Seconds")
                }
                .padding(.trailing, 30)
                .padding(.leading, 30)
                Group {
                    HStack {
                        Text("Turn on Text to Speech:")
                            .SFProFont(style: .headline, weight: .bold, multiplier: globals_Nav.multiplier)
                        Button("CHANGE", action: {
                            textToSpeech = !textToSpeech
                            globals_Nav.text = textToSpeech
                            GlobalVars_Unifier.text_unifier = textToSpeech
                            print("chagned val to ", textToSpeech)
                            
                        })
                        .background(Color(UIColor.lightGray))
                        .foregroundColor(.black)
                        

                        if (textToSpeech) {
                            Text("ON").SFProFont(style: .body, weight:.regular, multiplier: sliderValue)

                        }
                        else {
                            Text("OFF").SFProFont(style: .body, weight:.regular, multiplier: sliderValue)

                        }
                    }
                    .SFProFont(style: .body, weight: .regular, multiplier: globals_Nav.multiplier)
                    .environmentObject(globals_Nav)
                    
                    HStack {
                        if textToSpeech {
                            Text("Text to Speech On")
                        }
                        else {
                            Text("Text to Speech Off")
                        }
                        Toggle("Text to Speech On", isOn: $textToSpeech)
                            .onChange(of: textToSpeech) { value in
                                GlobalVars_Unifier.text_unifier = textToSpeech
                                print("change val to \(textToSpeech) using toggle")
                            }
                            .labelsHidden()
                            .padding(10)
                    }
                }
                .padding(.trailing, 30)
                .padding(.leading, 30)
                
                Group {
                    // scan for peripherals
                    HStack {
                        Text("Connect to Flex Sensor")
                        Spacer()
                        Button(action: {
                            bleController.startScanning()
                        }, label: {
                            Text("Scan")
                        })
                        .disabled(bleController.scanningBtnDisabled)
                    }
                    if (!bleController.bleConnected) {
                        Text(bleController.scanningText)
                        // dicovered peripheral names
                        List {
                            ForEach(0..<bleController.peripheralArray.count, id: \.self) { i in
                                Button(action: {
                                    bleController.selectPeripheral(index: i)
                                }, label: {
                                    Text(bleController.peripheralArray[i].name ?? "")
                                })
                            }
                        }
                    }
                    else {
                        // discovered peripherals
                        Text("Connected to \(bleController.peripheralName)")
                        Button(action: {
                            bleController.calibrateFlexSensor()
                        }, label: {
                            Text("Calibrate Flex Sensor")
                        })
                    }
                }
                .padding(.trailing, 30)
                .padding(.leading, 30)
            }
        }
        .onAppear(perform: {
            sliderValue = GlobalVars_Unifier.multiplier_unifier
            textToSpeech = GlobalVars_Unifier.text_unifier
            bleController.loadBleController()
        })
        .padding(.top, 80)
        .edgesIgnoringSafeArea(.top)
    }
//    .navigationBarTitle(Text("Settings"), displayMode: .large)
//    .navigationViewStyle(StackNavigationViewStyle())
//    .edgesIgnoringSafeArea(.all)
//    .environmentObject(globals_Nav)
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView().environmentObject(GlobalVars())
            SettingsView().environmentObject(GlobalVars())
        }
    }
}
