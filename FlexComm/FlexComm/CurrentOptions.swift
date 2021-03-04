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
    
    func addOption() {
        if (self.options.count < 6) {
            self.options.append("")
        }
    }
    
    func deleteOption() {
        if (self.options.count > 0) {
            self.options.removeLast()
        }
    }
}
