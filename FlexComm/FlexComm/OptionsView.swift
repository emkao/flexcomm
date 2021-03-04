//
//  OptionsView.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import SwiftUI

struct OptionsView: View {
    var body: some View {
        
        VStack {
            //Menu Bar on top
            HStack {
                Button(action: { // back button
                    print("Go back")
                }) {
                    Text("Menu")
                }
                
                Spacer()
                Button(action: {// settings button
                    print("Go to settings")
                }) {
                    Text("Settings")
                }
             
                
            }
            .foregroundColor(.black)
            .padding(10.0)
            
            
            
            Spacer()
            // cards in a hstack
            VStack {
                Button(action: {
                    print("Play yes")
                }) {
                    Text("YES")
                        
                }
                .frame(width: 200, height: 200)
                .background(Color("LeafGreen"))
                .padding(.all)
                
                
                Button(action: {
                    print("Play No")
                }) {
                    Text("NO")
                        
                }
                .frame(width: 200, height: 200)
                .background(Color(.red))
                .padding(.all)
                
            }
            .foregroundColor(.white)
            Spacer()
            
            
        }
        .customFont(name: "SFProText-Thin", style: .largeTitle)
        
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
