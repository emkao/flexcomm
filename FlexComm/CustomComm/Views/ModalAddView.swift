//
//  ModalAddView.swift
//  FlexComm
//
//  Created by emily kao on 3/5/21.
//

import SwiftUI

enum activeSheet: Identifiable {
    case first, second
    
    var id: Int {
        hashValue
    }
}

struct ModalAddView: View {
    @EnvironmentObject var currentOptions: CurrentOptions
  //  @EnvironmentObject var globals_old
    @EnvironmentObject var globals: GlobalVars
//    @StateObject var globals = GlobalVars()
    @Binding var showAddModal: Bool
    @State private var btnText: String = ""
    @State private var btnIsFolder: Int = 0
    @State private var btnImage: UIImage = UIImage()
    @State private var imageSource: activeSheet?
    var isFolderOptions = ["Option", "Folder"]
    
    var body: some View {
        VStack {
            Text("Add Option")
                .font(.custom("SFProText-Thin", size: 50))
                .padding(20)
            Form {
                Section(header: Text("Option")) {
                    Picker(selection: $btnIsFolder, label: Text("Option is a ")) {
                        ForEach(0 ..< isFolderOptions.count) {
                            Text(self.isFolderOptions[$0])
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
                                .scaledToFill()
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
                    self.showAddModal.toggle()
                }, label: {
                    Text("Cancel")
                })
                .padding(30)
                
                Spacer()
                
                Button(action: {
                    currentOptions.addOption(text: btnText, image: btnImage, isFolder: (btnIsFolder == 1))
                    self.showAddModal.toggle()
                }, label: {
                    Text("Add")
                })
                .padding(30)
            }
        }
        Spacer()
    }
}
