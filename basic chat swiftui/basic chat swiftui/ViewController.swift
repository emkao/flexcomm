//
//  ViewController.swift
//  basic chat swiftui
//
//  Created by emily kao on 4/7/21.
//

import Foundation
import CoreBluetooth
import UIKit

class ViewController: UIViewController, ObservableObject {
    
    private var centralManager: CBCentralManager!
    private var bluefruitPeripheral: CBPeripheral!
    private var txCharacteristic: CBCharacteristic!
    private var rxCharacteristic: CBCharacteristic!
    var peripheralArray: [CBPeripheral] = []
    var rssiArray = [NSNumber]()
    private var timer = Timer()
    
    @Published var changeView: Bool = false
    @Published var scanningText: String = ""
    @Published var scanningBtnDisabled: Bool = false
    @Published var peripheralText: String = ""
    @Published var rssiText: String = ""
    
    var peripheralManager: CBPeripheralManager?
    var peripheral: CBPeripheral?
    var peripheralTXCharacteristic: CBCharacteristic?
    
    @Published var serviceText: String = ""
    @Published var txText: String = ""
    @Published var rxText: String = ""
    @Published var consoleTextView: String!
    @Published var consoleText: String = ""
    
    func loadViewController() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
//        Static.instance.centralManager = CBCentralManager(delegate: self, queue: nil)
        self.changeView = false
    }
    
    func loadConsoleController() {
        keyboardNotifications()
        consoleTextView = ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appendRxDataToTextView(notification:)), name: NSNotification.Name(rawValue: "Notify"), object: nil)
        
//        BlePeripheral.connectedPeripheral = Static.instance.bluefruitPeripheral
        
//        print(Static.instance.bluefruitPeripheral)
//        print(BlePeripheral.connectedPeripheral?.name)
        
        peripheralText = (BlePeripheral.connectedPeripheral?.name!)!
//        peripheralText = Static.instance.bluefruitPeripheral.name!
        
        txText = "TX:\(String(BlePeripheral.connectedTXChar!.uuid.uuidString))"
        rxText = "RX:\(String(BlePeripheral.connectedRXChar!.uuid.uuidString))"
        
        if let service = BlePeripheral.connectedService {
            serviceText = "Number of Services: \(String((BlePeripheral.connectedPeripheral?.services!.count)!))"
        }
        else {
            print("Service was not found")
        }
    }

    func connectToDevice() -> Void {
        centralManager?.connect(bluefruitPeripheral!, options: nil)
//        Static.instance.centralManager?.connect(Static.instance.bluefruitPeripheral!, options: nil)
    }
    
    func disconnectFromDevice() -> Void {
        if bluefruitPeripheral != nil {
            centralManager?.cancelPeripheralConnection(bluefruitPeripheral!)
//            Static.instance.centralManager?.cancelPeripheralConnection(Static.instance.bluefruitPeripheral!)
        }
//        if Static.instance.bluefruitPeripheral != nil {
//            Static.instance.centralManager?.cancelPeripheralConnection(Static.instance.bluefruitPeripheral!)
//        }
    }
    
    func removeArrayData() -> Void {
        centralManager.cancelPeripheralConnection(bluefruitPeripheral)
//        Static.instance.centralManager.cancelPeripheralConnection(Static.instance.bluefruitPeripheral)
        rssiArray.removeAll()
        peripheralArray.removeAll()
    }
    
    func startScanning() -> Void {
        // remove prior data
        peripheralArray.removeAll()
        rssiArray.removeAll()
        // start scanning
        centralManager?.scanForPeripherals(withServices: [CBUUIDs.BLEService_UUID])
//        Static.instance.centralManager?.scanForPeripherals(withServices: [CBUUIDs.BLEService_UUID])
        self.scanningText = "Scanning..."
        self.scanningBtnDisabled = true
        Timer.scheduledTimer(withTimeInterval: 15, repeats: false) {_ in
            self.stopScanning()
        }
    }
    
    func scanForBLEDevices() -> Void {
        // remove prior data
        peripheralArray.removeAll()
        rssiArray.removeAll()
        // start scanning
//        Static.instance.centralManager?.scanForPeripherals(withServices: [], options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        centralManager?.scanForPeripherals(withServices: [], options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        self.scanningText = "Scanning..."
        
        Timer.scheduledTimer(withTimeInterval: 15, repeats: false) {_ in
            self.stopScanning()
        }
    }
    
    func writeOutgoingValue(data: String) {
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        if let blePeripheral = BlePeripheral.connectedPeripheral {
            if let txCharacteristic = BlePeripheral.connectedTXChar {
                blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    func stopTimer() -> Void {
        // stops timer
        self.timer.invalidate()
    }
    
    func stopScanning() -> Void {
        self.scanningText = ""
        self.scanningBtnDisabled = false
//        Static.instance.centralManager?.stopScan()
        centralManager?.stopScan()
    }
    
    func delayedConnection() -> Void {
        BlePeripheral.connectedPeripheral = bluefruitPeripheral
//        Static.instance.bluefruitPeripheral = BlePeripheral
        self.changeView = true
//        print(Static.instance.bluefruitPeripheral)
        // double check this
    }
    
    func numPeripherals() -> Int {
        return self.peripheralArray.count
    }
    
    func selectPeripheral(index: Int) -> Void {
        bluefruitPeripheral = peripheralArray[index]
//        Static.instance.bluefruitPeripheral = peripheralArray[index]
        BlePeripheral.connectedPeripheral = bluefruitPeripheral
//        Static.instance.bluefruitPeripheral = BlePeripheral
        connectToDevice()
    }
    
    @objc func appendRxDataToTextView(notification: Notification) -> Void {
        consoleTextView.append("\n[Recv]: \(notification.object!) \n")
    }
    
    func appendTxDataToTextView() {
        consoleTextView.append("\n[Sent]: \(String(consoleText)) \n")
    }
    
    func keyboardNotifications() {
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

      NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)

      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    deinit {
      NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
      NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print(keyboardHeight)
            view.frame.origin.y = (-keyboardHeight + 50)
        }
    }
    
    @objc func keyboardDidHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    @objc func disconnectPeripheral() {
        print("Disconnect for peripheral")
    }
    
    func writeCharacteristic(incomingValue: Int8) {
        var val = incomingValue
        
        let outgoingData = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
        peripheral?.writeValue(outgoingData as Data, for: BlePeripheral.connectedTXChar!, type: CBCharacteristicWriteType.withResponse)
    }
}

extension ViewController: CBPeripheralManagerDelegate {
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
    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        var characteristicASCIIValue = NSString()
//
//        guard characteristic == rxCharacteristic,
//              let characteristicValue = characteristic.value,
//              let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else {
//            return
//        }
//
//        characteristicASCIIValue = ASCIIstring
//
//        print("Value Recieved: \((characteristicASCIIValue as String))")
//    }
}

extension ViewController: CBCentralManagerDelegate {
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
        print("discovered")
        bluefruitPeripheral = peripheral
//        Static.instance.bluefruitPeripheral = peripheral
        
        if peripheralArray.contains(peripheral) {
            print("Duplicate Found.")
        } else {
            peripheralArray.append(peripheral)
            rssiArray.append(RSSI)
        }
        
        self.peripheralText = "Peripherals Found: \(peripheralArray.count)"
//        Static.instance.bluefruitPeripheral.delegate = self
        bluefruitPeripheral.delegate = self
        
        print("Peripheral Discovered: \(peripheral)")
        print("Peripheral Name: \(String(describing: peripheral.name))")
        print("Advertisement Data: \(advertisementData)")
        
        centralManager?.connect(bluefruitPeripheral, options: nil)
//        Static.instance.centralManager?.connect(Static.instance.bluefruitPeripheral, options: nil)
        // TODO
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        stopScanning()
        bluefruitPeripheral.discoverServices([CBUUIDs.BLEService_UUID])
//        Static.instance.bluefruitPeripheral.discoverServices([CBUUIDs.BLEService_UUID])
    }
}

extension ViewController: CBPeripheralDelegate {
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
        delayedConnection()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

        var characteristicASCIIValue = NSString()

        guard characteristic == rxCharacteristic,
            let characteristicValue = characteristic.value,
            let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }
        
        characteristicASCIIValue = ASCIIstring

        print("Value Recieved: \((characteristicASCIIValue as String))")

        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: "\((characteristicASCIIValue as String))")
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
