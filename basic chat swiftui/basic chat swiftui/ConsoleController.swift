//
//  ConsoleController.swift
//  basic chat swiftui
//
//  Created by emily kao on 4/7/21.
//

import Foundation
import UIKit
import CoreBluetooth

class ConsoleController: UIViewController, ObservableObject {
    
    var peripheralManager: CBPeripheralManager?
    var peripheral: CBPeripheral?
    var peripheralTXCharacteristic: CBCharacteristic?
    
    @Published var peripheralText: String!
    @Published var serviceText: String!
    @Published var txText: String!
    @Published var rxText: String!
    @Published var consoleTextView: String!
    @Published var consoleText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appendRxDataToTextView(notification:)), name: NSNotification.Name(rawValue: "Notify"), object: nil)
        
        peripheralText = BlePeripheral.connectedPeripheral?.name
        
        txText = "TX:\(String(BlePeripheral.connectedTXChar!.uuid.uuidString))"
        rxText = "RX:\(String(BlePeripheral.connectedRXChar!.uuid.uuidString))"
        
        if let service = BlePeripheral.connectedService {
            serviceText = "Number of Services: \(String((BlePeripheral.connectedPeripheral?.services!.count)!))"
        }
        else {
            print("Service was not found")
        }
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
    
    func writeOutgoingValue(data: String) {
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        if let blePeripheral = BlePeripheral.connectedPeripheral {
            if let txCharacteristic = BlePeripheral.connectedTXChar {
                blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    func writeCharacteristic(incomingValue: Int8) {
        var val = incomingValue
        
        let outgoingData = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
        peripheral?.writeValue(outgoingData as Data, for: BlePeripheral.connectedTXChar!, type: CBCharacteristicWriteType.withResponse)
    }
}

extension ConsoleController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("peripheral is powered on")
        case .unsupported:
            print("peripheral is unsupported")
        case .unauthorized:
            print("peripheral is unauthorized")
        case .unknown:
            print("peripheral unknown")
        case .resetting:
            print("peripheral resetting")
        case .poweredOff:
            print("peripheral is powered off")
        @unknown default:
            print("Error")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("device subscribe to characteristic")
    }
}
