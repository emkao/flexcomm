//
//  CurrentOptions.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import Foundation

class CurrentOptions: ObservableObject {
    @Published var options = [ButtonOption]()
    @Published var selectedBtn: Int = 0
    var timer: Timer?
    
    init() {
        self.options = [ButtonOption(text: "Yes"), ButtonOption(text: "No")]
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) {_ in
            self.selectedBtn = (self.selectedBtn + 1) % self.options.count
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
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
    }
    
    func editOption(index: Int, text: String) {
        self.options[index].text = text
    }
}

