//
//  ContentView.swift
//  FlexCommPersonal
//
//  Created by Ankita Satyavarapu on 2/22/21.
//  Copyright © 2021 Ankita Satyavarapu. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
//    @EnvironmentObject var responseValidate: responseValidator
    @State private var responseTime = ""
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "SFProText-Thin", size: 50)!]
    }

    var body: some View {
        NavigationView {
            ZStack{
                Color.white
                VStack{
                    HStack{
                        Text("Color Scheme:")
                            .SFProFont(style: .headline, weight: .bold)
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
                    .SFProFont(style: .body, weight: .regular)
                    .padding()
                    HStack{
                        Text("Font Size:")
                            .SFProFont(style: .headline, weight: .bold)
                        Button(action: {
                            print("Small Font Tapped")
                            GlobalVars.bigFontOn = false
                
                            
                        }) {
                            Text("Small Font")
                             .padding()
                            .SFProFont(style: .body, weight: .bold)
                            .background(Color(UIColor.lightGray))
                            .foregroundColor(.black)
                            .cornerRadius(40)

                        }
                        Button(action: {
                            print("Big Font Tapped")
                            GlobalVars.bigFontOn = true
                            print(GlobalVars.bigFontOn)
                        }) {
                            Text("Big Font")
                            .padding()
                            .SFProFontBig(style: .title1, weight: .bold)
                            .background(Color(UIColor.lightGray))
                            .foregroundColor(.black)
                            .cornerRadius(40)
                        }

                    }


                    HStack{
                        Text("Response Time:")
                            .SFProFont(style: .headline, weight: .bold)

//                        TextField("Number of Seconds", text: $responseValidate.responseTime)
                        TextField("Number of Seconds", text: $responseTime)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Seconds")

                    }
                    .SFProFont(style: .body, weight: .regular)

                }
            }
            .navigationBarTitle(Text("Settings"), displayMode: .large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
       // SettingsView().environmentObject(responseValidator())
        SettingsView()
    }
}
