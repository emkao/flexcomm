//
//  CurrentOptions.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import Foundation

class CurrentOptions: ObservableObject, Codable {
    enum CodingOptions: CodingKey {
        case options
    }
    
    @Published var options = [ButtonOption]() {
        didSet {
            print("savingggg")
            save()
        }
    }
    @Published var selectedBtn: Int = 0
    var timer: Timer?
    
    init() {
        if let options = UserDefaults.standard.data(forKey: "saved_options") {
            let decoder = PropertyListDecoder()
            if let decoded = try? decoder.decode([ButtonOption].self, from: options) {
                self.options = decoded
                return
            }
            self.options = [ButtonOption(text: "Yes"), ButtonOption(text: "No")]
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingOptions.self)
        try container.encode(self.options, forKey: .options)
    }
    
    required init(from decoder: Decoder) throws {
        let options = try decoder.container(keyedBy: CodingOptions.self)

        if let decoded = try? options.decode([ButtonOption].self, forKey: .options) {
            self.options = decoded
            return
        }
        self.options = [ButtonOption(text: "Yes"), ButtonOption(text: "No")]
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) {_ in
            self.selectedBtn = (self.selectedBtn + 1) % self.options.count
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
    }
    
    func addOption(text: String) {
        if (self.options.count < 6) {
            self.options.append(ButtonOption(text: text))
        }
    }
    
    func deleteOption(removeIndices: [Int]) {
        for index in stride(from: removeIndices.count - 1, to: -1, by: -1) {
            self.options.remove(at: removeIndices[index])
        }
    }
    
    func editOption(index: Int, text: String) {
        self.options[index].text = text
    }
    
    func save() {
        if let encoded = try? PropertyListEncoder().encode(options) {
            UserDefaults.standard.set(encoded, forKey: "saved_options")
        }
    }
}

