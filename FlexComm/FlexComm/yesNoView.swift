//
//  yesNoView.swift
//
//  Created by Marisa O'Gara on 2/22/21.
//

import SwiftUI
import UIKit

struct yesNoView: View {
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

struct yesNoView_Previews: PreviewProvider {
    static var previews: some View {
                // change layout so it matches iPads Mini
                yesNoView()
//                    .previewLayout(.fixed(width: 1024, height: 768))
            
        }

    }
    


