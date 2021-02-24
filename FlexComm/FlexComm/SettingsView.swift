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
                            .customFont(name: "SFProText-Thin", style: .headline, weight: .bold)
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
                    .customFont(name: "SFProText-Thin", style: .body)
                    .padding()
                    HStack{
                        Text("Font Size:")
                            .customFont(name: "SFProText-Thin", style: .headline, weight: .bold)
                        Button(action: {
                            print("Small Font Tapped")
                        }) {
                            Text("Small Font")
                             .padding()
                                .customFont(name: "SFProText-Thin", style: .body, weight: .bold)
                            .background(Color(UIColor.lightGray))
                            .foregroundColor(.black)
                            .cornerRadius(40)

                        }
                        Button(action: {
                            print("Big Font Tapped")
                        }) {
                            Text("Big Font")
                            .padding()
                                .customFont(name: "SFProText-Thin", style: .title1, weight: .bold)
                            .background(Color(UIColor.lightGray))
                            .foregroundColor(.black)
                            .cornerRadius(40)
                        }

                    }


                    HStack{
                        Text("Response Time:")
                            .customFont(name: "SFProText-Thin", style: .headline, weight: .bold)

//                        TextField("Number of Seconds", text: $responseValidate.responseTime)
                        TextField("Number of Seconds", text: $responseTime)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Seconds")

                    }
                    .customFont(name: "SFProText-Thin", style: .body)

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
