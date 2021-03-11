//
//  GlobalVars.swift
//  FlexComm
//
//  Created by Marisa O'Gara on 3/9/21.
//

import Foundation
class GlobalVars: ObservableObject {
   //static var bigFontOn = false
    @Published var multiplier  = GlobalVars2.mult
    
    
}
struct GlobalVars2 {
    static var mult =  1.0;
    
}
