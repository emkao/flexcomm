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
    @ObservedObject var bleController: BLEController
    @StateObject var globals_Nav = GlobalVars()
    @State private var responseTime = "2"
    @State private var sliderValue = GlobalVars().multiplier
    @State private var textToSpeech = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 30) {
                HStack {
                    Button(action: { // back button
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                    .padding(.leading, 30)
                    .padding(.top, 30)
                    Spacer()
                }
                Text("Settings")
                    .font(.custom("SFProText-Thin", size: 50))
                    .padding(0)
//                Group {
//                    HStack{
//                        Text("Color Scheme:")
//                            .SFProFont(style: .headline, weight: .bold, multiplier: globals_Nav.multiplier)
//                        Button(action: {
//                            print("Dark Mode tapped!")
//                        }) {
//                            Text("Dark Mode")
//                            .padding()
//                            .background(Color.black)
//                            .foregroundColor(.white)
//                            .cornerRadius(40)
//                        }
//                        Button(action: {
//                            print("Light Mode tapped!")
//                        }) {
//                            Text("Light Mode")
//                            .padding()
//                            .background(Color(UIColor.lightGray))
//                            .foregroundColor(.black)
//                            .cornerRadius(40)
//                        }
//                    }
//                    .SFProFont(style: .body, weight: .regular, multiplier: globals_Nav.multiplier)
//                    .padding()
//                }
                Group {
                    Text("All sound effects obtained from https://www.zapsplat.com")
                        .SFProFont(style: .body, weight:.regular, multiplier: sliderValue)
                    
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
                    TextField("Number of Seconds", text: $responseTime).onChange(of: responseTime, perform: { value in
//                        GlobalVars_Unifier.time_unifier = Double(responseTime) ?? 2.0
//                        globals_Nav.time = Double(responseTime) ?? 2.0
//                        print("changed time to : ", GlobalVars_Unifier.time_unifier)
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Seconds")
                    Button(action: {
                        GlobalVars_Unifier.time_unifier = Double(responseTime) ?? 2.0
                        globals_Nav.time = Double(responseTime) ?? 2.0
                        print("changed time to : ", GlobalVars_Unifier.time_unifier)
                    }, label: {
                        Text("Set Response Time")
                    })
                    .padding()
                    .SFProFont(style: .body, weight: .bold, multiplier: globals_Nav.multiplier)
                    .background(Color(UIColor.lightGray))
                    .foregroundColor(.black)
                    .cornerRadius(40)
                }
                .padding(.trailing, 30)
                .padding(.leading, 30)
                
                Group {
//                    HStack {
//                        Text("Turn on Text to Speech:")
//                            .SFProFont(style: .headline, weight: .bold, multiplier: globals_Nav.multiplier)
//                        Button("CHANGE", action: {
//                            textToSpeech = !textToSpeech
//                            globals_Nav.text = textToSpeech
//                            GlobalVars_Unifier.text_unifier = textToSpeech
//                            print("chagned val to ", textToSpeech)
//                            
//                        })
//                        .background(Color(UIColor.lightGray))
//                        .foregroundColor(.black)
//                        
//
//                        if (textToSpeech) {
//                            Text("ON").SFProFont(style: .body, weight:.regular, multiplier: sliderValue)
//
//                        }
//                        else {
//                            Text("OFF").SFProFont(style: .body, weight:.regular, multiplier: sliderValue)
//
//                        }
//                    }
//                    .SFProFont(style: .body, weight: .regular, multiplier: globals_Nav.multiplier)
//                    .environmentObject(globals_Nav)
//                    
                    HStack {
                        if textToSpeech {
                            Text("Text to Speech On")
                                .SFProFont(style: .body, weight:.regular, multiplier: sliderValue)
                        }
                        else {
                            Text("Text to Speech Off")
                                .SFProFont(style: .body, weight:.regular, multiplier: sliderValue)
                        }
                        Toggle("Text to Speech On", isOn: $textToSpeech)
                            .onChange(of: textToSpeech) { value in
                                GlobalVars_Unifier.text_unifier = textToSpeech
                                globals_Nav.text = textToSpeech
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
                        Text("Connect to Flex Sensor:")
                            .SFProFont(style: .headline, weight:.bold, multiplier: sliderValue)
                        Spacer()
                        Button(action: {
                            bleController.startScanning()
                        }, label: {
                            Text("Scan")
//                                .SFProFont(style: .body, weight:.regular, multiplier: sliderValue)
                        })
                        .disabled(bleController.scanningBtnDisabled)
                    }
                    if (!bleController.bleConnected) {
                        if bleController.scanningText != "" {
                            Text(bleController.scanningText)
                        }
                        // dicovered peripheral names
                        Text("Discovered Devices: ")
                            .SFProFont(style: .body, weight:.regular, multiplier: sliderValue)
                        GeometryReader { geo in
                            List {
                                ForEach(0..<bleController.peripheralArray.count, id: \.self) { i in
                                    Button(action: {
                                        bleController.selectPeripheral(index: i)
                                    }, label: {
                                        Text(bleController.peripheralArray[i].name ?? "")
                                    })
                                }
                            }
                            .frame(width: geo.size.width, height: geo.size.height * 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(lineWidth: 2.0)
                            )
                        }
                        Spacer()
                    }
                    else {
                        // discovered peripherals
                        Text("Connected to \(bleController.peripheralName)")
                            .SFProFont(style: .body, weight:.regular, multiplier: sliderValue)
                        NavigationLink(
                            destination: CalibrateView().environmentObject(bleController),
                            label: {
                                Text("Calibrate Flex Sensor")
                                    .SFProFont(style: .body, weight:.regular, multiplier: sliderValue)
                            })
//                            .buttonStyle(PlainButtonStyle())
                            .padding()
                            .border(Color.black)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                        Button(action: {
                            bleController.disconnectFromDevice()
                        }, label: {
                            Text("Disconnect from Flex Sensor")
                                .SFProFont(style: .body, weight:.regular, multiplier: sliderValue)
                        })
                        Spacer()
                    }
                }
                .padding(.trailing, 30)
                .padding(.leading, 30)
            }
            .edgesIgnoringSafeArea(.top)
            .padding(.top, 0)
        }
        .onAppear(perform: {
            sliderValue = GlobalVars_Unifier.multiplier_unifier
            textToSpeech = GlobalVars_Unifier.text_unifier
            responseTime = String(GlobalVars_Unifier.time_unifier)
            bleController.loadBleController()
        })
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}
