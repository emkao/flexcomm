//
//  responseValidate.swift
//  FlexCommPersonal
//
//  Created by Ankita Satyavarapu on 2/23/21.
//  Copyright © 2021 Ankita Satyavarapu. All rights reserved.
//

import Foundation
import SwiftUI


class responseValidator: ObservableObject {
        @Published var responseTime = "" {
        didSet {
            let string = self.responseTime
            let num = Int(string)
            if num != nil  {
                self.responseTime = ""
            }
        }
    }
    
}
