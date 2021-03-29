//
//  ButtonOption.swift
//  FlexComm
//
//  Created by emily kao on 3/7/21.
//

import Foundation
import SwiftUI

final class ButtonOption { // Encodable, Decodable
    var text: String
    var image: UIImage
    var children: [ButtonOption]
    var siblings: [ButtonOption]
    var parent: ButtonOption?
    var isFolder: Bool
    var selected: Bool
    
    init() {
        self.text = ""
        self.image = UIImage()
        self.children = []
        self.siblings = []
        self.isFolder = false
        self.selected = false
    }
    
    init(text: String, isFolder: Bool) {
        self.text = text
        self.image = UIImage()
        self.children = []
        self.siblings = []
        self.isFolder = isFolder
        self.selected = false
    }
    
    init(text: String, image: String, isFolder: Bool) {
        self.text = text
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        self.image = UIImage(systemName: image)?.withRenderingMode(.alwaysTemplate).withConfiguration(config) ?? UIImage()
        self.image.withTintColor(.white)
        self.children = []
        self.siblings = []
        self.isFolder = isFolder
        self.selected = false
    }
    
    init(text: String, image: UIImage, isFolder: Bool) {
        self.text = text
        self.image = image
        self.children = []
        self.siblings = []
        self.isFolder = isFolder
        self.selected = false
    }
    
    func addChild(child: ButtonOption) {
        children.append(child)
        child.parent = self
    }
    
    func addChildren(children: [ButtonOption]) {
        for child in children {
            child.siblings = children
            addChild(child: child)
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
