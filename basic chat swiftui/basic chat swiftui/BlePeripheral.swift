//
//  BlePeripheral.swift
//  basic chat swiftui
//
//  Created by emily kao on 4/7/21.
//

import Foundation
import CoreBluetooth

class BlePeripheral {
    static var connectedPeripheral: CBPeripheral?
    static var connectedService: CBService?
    static var connectedTXChar: CBCharacteristic?
    static var connectedRXChar: CBCharacteristic? 
}
