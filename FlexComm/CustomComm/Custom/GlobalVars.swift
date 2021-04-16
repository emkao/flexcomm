//
//  GlobalVars.swift
//  FlexComm
//
//  Created by Marisa O'Gara on 3/9/21.
//

import Foundation
class GlobalVars: ObservableObject {
    @Published var multiplier  = GlobalVars_Unifier.multiplier_unifier
    @Published var text = GlobalVars_Unifier.text_unifier
    @Published var time = GlobalVars_Unifier.time_unifier
}
struct GlobalVars_Unifier{
    static var multiplier_unifier =  1.0;
    static var text_unifier = false
    static var time_unifier = 2.0
}
