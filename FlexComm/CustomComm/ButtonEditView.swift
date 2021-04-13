//
//  ButtonEditView.swift
//  FlexComm
//
//  Created by emily kao on 3/7/21.
//

import SwiftUI

struct ButtonEditView: View {
    @EnvironmentObject var currentOptions: CurrentOptions
    @StateObject var globals: GlobalVars
    @Binding var selectedButton: Int
    @Binding var editButton: Bool
    @State private var btnText: String = ""
    @State private var btnIsFolder: Int = 0
    @State private var btnImage: UIImage = UIImage()
    @State private var imageSource: activeSheet?
    var isFolderOptions = ["Option", "Folder"]
    
    var body: some View {
        VStack {
            Text("Edit \(currentOptions.allOptions[currentOptions.options[selectedButton]]!.text)" as String)
                .font(.custom("SFProText-Thin", size: 50))
                .padding(20)
            Form {
                Section(header: Text("Options")) {
                    Picker(selection: $btnIsFolder, label: Text("Option is a ")) {
                        ForEach(0 ..< isFolderOptions.count) {
                            Text(self.isFolderOptions[$0]).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        Text("Option Text: ")
                        TextField("Enter Option Text", text: $btnText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("Option Image: ")
                            Spacer()
                            Image(uiImage: self.btnImage)
                                .resizable()
                                .padding(10)
                                .frame(minWidth: 0, maxWidth: 250, minHeight: 0, maxHeight: 250)
                                .scaledToFit()
                            Spacer()
                        }
                        Button(action: {
                            imageSource = .first
                        }, label: {
                            HStack {
                                Image(systemName: "camera")
                                Text("Camera")
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 45, maxHeight: 45)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.horizontal)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            imageSource = .second
                        }, label: {
                            HStack {
                                Image(systemName: "photo")
                                Text("Photo Library")
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 45, maxHeight: 45)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.horizontal)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    .sheet(item: $imageSource) {item in
                        switch item {
                        case .first:
                            ImagePicker(sourceType: .camera, selectedImage: self.$btnImage)
                        case .second:
                            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$btnImage)
                        }
                    }
                }
            }
            .SFProFont(style: .body, weight: .regular, multiplier: globals.multiplier)
            
            HStack {
                Button(action: {
                    self.editButton.toggle()
                }, label: {
                    Text("Cancel")
                })
                .padding(30)
                
                Spacer()
                
                Button(action: {
                    currentOptions.editOption(index: selectedButton, text: btnText, image: btnImage, isFolder: (btnIsFolder == 1))
                    self.editButton.toggle()
                }, label: {
                    Text("Done")
                })
                .padding(30)
            }
        }
        .onAppear(perform: {
            btnText = currentOptions.allOptions[currentOptions.options[selectedButton]]!.text
            btnImage = currentOptions.allOptions[currentOptions.options[selectedButton]]!.image.getImage()
            if currentOptions.allOptions[currentOptions.options[selectedButton]]!.isFolder {
                btnIsFolder = 1
            }
            else {
                btnIsFolder = 0
            }
        })
        Spacer()
    }
}
