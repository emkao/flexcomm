//
//  BLEController.swift
//  CustomComm
//
//  Created by emily kao on 4/12/21.
//

import Foundation
import CoreBluetooth
import UIKit

class BLEController: UIViewController, ObservableObject {
    // data structures
    var centralManager: CBCentralManager!
    var bluefruitPeripheral: CBPeripheral!
    var txCharacteristic: CBCharacteristic!
    var rxCharacteristic: CBCharacteristic!

    @Published var bleConnected: Bool = false
    // bleConnected = false
    @Published var peripheralArray: [CBPeripheral] = []
    @Published var rssiArray = [NSNumber]()
    @Published var scanningText: String = ""
    @Published var scanningBtnDisabled: Bool = false
    // bleConnected = true
    @Published var peripheralText: String = ""
    @Published var peripheralName: String = ""
    @Published var rssiText: String = ""
    @Published var txText: String = ""
    @Published var rxText: String = ""
    @Published var value: Int = 1
    
    @Published var selected: Bool = false
    
    var timer: Timer?
    var timeRemaining: Double = 100
    
    // before connection functions
    func loadBleController() {
        if (centralManager == nil) {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }
    
    func connectToDevice() -> Void {
        centralManager?.connect(bluefruitPeripheral, options: nil)
        bleConnected = true
    }
    
    func disconnectFromDevice() -> Void {
        if (bluefruitPeripheral != nil) {
            centralManager?.cancelPeripheralConnection(bluefruitPeripheral)
        }
        bleConnected = false
    }
    
    func startScanning() -> Void {
        // remove prior data
        peripheralArray.removeAll()
        rssiArray.removeAll()
        // start scanning
        centralManager?.scanForPeripherals(withServices: [CBUUIDs.BLEService_UUID])
        self.scanningText = "Scanning..."
        self.scanningBtnDisabled = true
        Timer.scheduledTimer(withTimeInterval: 15, repeats: false) {_ in
            self.stopScanning()
        }
    }
    
    func stopScanning() -> Void {
        self.scanningText = ""
        self.scanningBtnDisabled = false
        centralManager?.stopScan()
    }
    
    func selectPeripheral(index: Int) -> Void {
        bluefruitPeripheral = peripheralArray[index]
        BlePeripheral.connectedPeripheral = bluefruitPeripheral
        peripheralName = bluefruitPeripheral.name ?? ""
        connectToDevice()
        bleConnected = true
    }
    
    func delayedConnection() -> Void {
        BlePeripheral.connectedPeripheral = bluefruitPeripheral
        bleConnected = true
    }
    
    // after connection functions
    func writeOutgoingValue(data: String) {
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        if let blePeripheral = BlePeripheral.connectedPeripheral {
            if let txCharacteristic = BlePeripheral.connectedTXChar {
                blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    func calibrateFlexSensor() {
        writeOutgoingValue(data: String(value))
    }
}

extension BLEController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
            case .poweredOn:
                print("Peripheral Is Powered On.")
            case .unsupported:
                print("Peripheral Is Unsupported.")
            case .unauthorized:
            print("Peripheral Is Unauthorized.")
            case .unknown:
                print("Peripheral Unknown")
            case .resetting:
                print("Peripheral Resetting")
            case .poweredOff:
              print("Peripheral Is Powered Off.")
            @unknown default:
              print("Error")
        }
    }
}

extension BLEController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .poweredOff:
                print("is powered off")
                
                let alertVC = UIAlertController(title: "Bluetooth Required", message: "Check your Bluetooth Settings", preferredStyle: UIAlertController.Style.alert)
                
                let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                
                alertVC.addAction(action)
                
                self.present(alertVC, animated: true, completion: nil)

            case .poweredOn:
                print("is powered on")
                startScanning()
            case .unsupported:
                print("is unsupported")
            case .unauthorized:
                print("is unauthorized")
            case .unknown:
                print("unknown")
            case .resetting:
                print("resetting")
            @unknown default:
                print("error")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        bluefruitPeripheral = peripheral
        
        if peripheralArray.contains(peripheral) {
            print("Duplicate Found.")
        } else {
            peripheralArray.append(peripheral)
            rssiArray.append(RSSI)
        }
        
        self.peripheralText = "Peripherals Found: \(peripheralArray.count)"
        bluefruitPeripheral.delegate = self
        
        print("Peripheral Discovered: \(peripheral)")
        print("Peripheral Name: \(String(describing: peripheral.name))")
        print("Advertisement Data: \(advertisementData)")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        stopScanning()
        bluefruitPeripheral.discoverServices([CBUUIDs.BLEService_UUID])
    }
}

extension BLEController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("*******************************************************")

        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        guard let services = peripheral.services else {
            return
        }
        // we need to discover the all characteristic
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
        BlePeripheral.connectedService = services[0]
        print("Discovered Services: \(services)")
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        print("Found \(characteristics.count) characteristics")

        for characteristic in characteristics {
            if characteristic.uuid.isEqual(CBUUIDs.BLE_Characteristic_uuid_Rx) {
                rxCharacteristic = characteristic

                BlePeripheral.connectedRXChar = rxCharacteristic

                peripheral.setNotifyValue(true, for: rxCharacteristic!)
                peripheral.readValue(for: characteristic)

                print("RX Characteristic: \(rxCharacteristic.uuid)")
            }

            if characteristic.uuid.isEqual(CBUUIDs.BLE_Characteristic_uuid_Tx) {
                txCharacteristic = characteristic
                BlePeripheral.connectedTXChar = txCharacteristic
                print("TX Characteristic: \(txCharacteristic.uuid)")
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

        var characteristicASCIIValue = NSString()

        guard characteristic == rxCharacteristic,
            let characteristicValue = characteristic.value,
            let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }

        characteristicASCIIValue = ASCIIstring
        
        let prevVal = value
        value = characteristicASCIIValue .integerValue
        print("Value Recieved: \(value)")
        
        if (prevVal != value && value == 0) {
            selected = true
        }
        else {
            selected = false
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        peripheral.readRSSI()
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: error")
            return
        }
        print("Function: \(#function), Line: \(#line)")
        print("Message sent")
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("*******************************************************")
        print("Function: \(#function), Line: \(#line)")
        if (error != nil) {
            print("Error changing notification state: \(String(describing: error?.localizedDescription))")
        }
        else {
            print("Characteristic's value subscribed")
        }

        if (characteristic.isNotifying) {
            print("Subscribed. Notification has begun for: \(characteristic.uuid)")
        }
    }
}
