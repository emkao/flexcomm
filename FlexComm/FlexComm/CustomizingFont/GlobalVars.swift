//
//  GlobalVars.swift
//  FlexComm
//
//  Created by Marisa O'Gara on 3/9/21.
//

import Foundation
class GlobalVars: ObservableObject {
    @Published var multiplier  = GlobalVars_Unifier.multiplier_unifier
}
struct GlobalVars_Unifier{
    static var multiplier_unifier =  1.0;
    
}
