//
//  ContentView.swift
//  FlexCommPersonal
//
//  Created by Ankita Satyavarapu on 2/22/21.
//  Copyright © 2021 Ankita Satyavarapu. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var responseValidate: responseValidator
    @State private var responseTime = ""
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.white
                VStack{
                    HStack{
                        Text("Color Scheme:")
                            .font(.headline)
                            .fontWeight(.bold)
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
                    
                    .font(.body)
                    .font(Font.body.bold())
                    .padding()
                    HStack{
                        Text("Font Size:")
                            .font(.headline)
                            .fontWeight(.bold)
                        Button(action: {
                            print("Small Font Tapped")
                        }) {
                            Text("Small Font")
                             .padding()
                            .font(.body)
                            .background(Color(UIColor.lightGray))
                            .foregroundColor(.black)
                            .cornerRadius(40)
                            
                        }
                        Button(action: {
                            print("Big Font Tapped")
                        }) {
                            Text("Big Font")
                            .padding()
                           .font(.title)
                            .background(Color(UIColor.lightGray))
                            .foregroundColor(.black)
                            .cornerRadius(40)
                        }
                       
                    }
                    .font(Font.body.bold())
                    
                    
                    HStack{
                        Text("Response Time:")
                            .font(.headline)
                            .fontWeight(.bold)

                        TextField("Number of Seconds", text: $responseValidate.responseTime)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                        Text("Seconds")
                        
                    }
                    
                }
            }
            .navigationBarTitle("Settings")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(responseValidator())
    }
}
