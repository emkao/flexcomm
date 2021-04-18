//
//  CurrentOptions.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import Foundation
import SwiftUI
import UIKit

class CurrentOptions: ObservableObject {
    @Published var confirmSelected: Bool = false
    @Published var selectedBtn: Int = -1
    @Published var currLevel: Int = 0
    @Published var timer: Timer?

    func startTimer(count: Int) {
        print("timer start with count : \(count)")
        
        if(count == -1 ){
            self.selectedBtn = -1
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: GlobalVars_Unifier.time_unifier, repeats: true) {_ in
            if (count > 0) {
                self.selectedBtn = (self.selectedBtn + 1) % count
                print("the selected btn in start: ", self.selectedBtn)
            }
            else {
                self.selectedBtn = 0
            }
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
    }
}
