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
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var currentOptions: CurrentOptions
    @EnvironmentObject var globals: GlobalVars
    @Binding var showAddModal: Bool
    @State private var btnText: String = ""
    @State private var btnIsFolder: Int = 0
    @State private var btnImage: UIImage = UIImage()
    @State private var imageSource: activeSheet?
    var isFolderOptions = ["Option", "Folder"]
    @Binding var parent: ButtonOption?
    
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
                    let newOption = ButtonOption(context: viewContext)
                    newOption.text = btnText
                    if btnImage == UIImage() {
                        newOption.image = nil
                    }
                    else {
                        newOption.image = btnImage.pngData()!
                    }
                    newOption.isFolder = (btnIsFolder == 1)
                    newOption.level = parent!.level + 1
                    newOption.system = false
                    parent?.addToChildren(newOption)
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    currentOptions.stopTimer()
                    currentOptions.startTimer(count: (parent?.children!.count)!)
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
