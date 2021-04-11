//
//  Static.swift
//  basic chat swiftui
//
//  Created by emily kao on 4/11/21.
//

import Foundation
import CoreBluetooth

class Static {
    private init(){ }
    static let instance = Static()
    var centralManager: CBCentralManager!
    var bluefruitPeripheral: BlePeripheral!
}
