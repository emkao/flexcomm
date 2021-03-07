//
//  CurrentOptions.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import Foundation

class CurrentOptions: ObservableObject {
    @Published var options = [String]()
    
    init() {
        self.options = ["Yes", "No"]
    }
    
    func addOption(text: String) {
        if (self.options.count < 6) {
            self.options.append(text)
        }
    }
    
    func deleteOption(selections: [String]) {
        let set = Set(selections)
        if (self.options.count > 0) {
            self.options = self.options.filter{ !set.contains($0) }
        }
    }
    
    func editOption(index: Int, text: String) {
        self.options[index] = text
    }
}
