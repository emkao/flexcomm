//
//  ButtonOption.swift
//  FlexComm
//
//  Created by emily kao on 3/7/21.
//

import Foundation
import SwiftUI

final class ButtonOption: Encodable, Decodable {
    var text: String
    private(set) var children: [ButtonOption]
    private(set) var siblings: [ButtonOption]
    var parent: ButtonOption?
    
    init() {
        self.text = ""
        self.children = []
        self.siblings = []
    }
    
    init(text: String) {
        self.text = text
        self.children = []
        self.siblings = []
    }
    
    init(text: String, children: [ButtonOption], siblings: [ButtonOption], parent: ButtonOption) {
        self.text = text
        self.children = children
        self.siblings = siblings
        self.parent = parent
    }
    
    func addChild(child: ButtonOption) {
        children.append(child)
    }
    
    func addChildren(children: [ButtonOption]) {
        for child in children {
            addChild(child: child)
            child.siblings = children
        }
    }
    
    func addSibling(sibling: ButtonOption) {
        siblings.append(sibling)
    }
    
    func removeChild(index: Int) {
        for child in children {
            if let idx = child.siblings.firstIndex(where: {$0.text == children[index].text} ) {
                child.siblings.remove(at: idx)
            }
        }
        children.remove(at: index)
    }
    
    func removeChildren(removeIndices: [Int]) {
        for index in stride(from: removeIndices.count - 1, to: -1, by: -1) {
            removeChild(index: removeIndices[index])
        }
    }
}
