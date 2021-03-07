//
//  CurrentOptions.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import Foundation

class CurrentOptions: ObservableObject {
    @Published var options = [ButtonOption]()
    
    init() {
        self.options = [ButtonOption(text: "Yes"), ButtonOption(text: "No")]
    }
    
    func addOption(text: String) {
        if (self.options.count < 6) {
            self.options.append(ButtonOption(text: text))
        }
    }
    
    func deleteOption(removeIndices: [Int]) {
        for (index, _) in removeIndices.reversed().enumerated() {
            self.options.remove(at: index)
        }
//
//        let rmIdx = Set(removeIndices)
//        let keep_set = Set(options.indices).subtract(rmIdx)
//        if (self.options.count > 0) {
//            self.options = self.options.filter{ !set.contains($0) }
//        }
    }
    
    func editOption(index: Int, text: String) {
        self.options[index].text = text
    }
}
