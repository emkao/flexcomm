//
//  ButtonOption+CoreDataProperties.swift
//  CustomComm
//
//  Created by emily kao on 4/18/21.
//
//

import Foundation
import CoreData


extension ButtonOption {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ButtonOption> {
        return NSFetchRequest<ButtonOption>(entityName: "ButtonOption")
    }

    @NSManaged public var text: String
    @NSManaged public var image: Data?
    @NSManaged public var isFolder: Bool
    @NSManaged public var level: Int
    @NSManaged public var selected: Bool
    @NSManaged public var system: Bool
    @NSManaged public var children: NSOrderedSet?
    @NSManaged public var parent: ButtonOption?

}

// MARK: Generated accessors for children
extension ButtonOption {

    @objc(insertObject:inChildrenAtIndex:)
    @NSManaged public func insertIntoChildren(_ value: ButtonOption, at idx: Int)

    @objc(removeObjectFromChildrenAtIndex:)
    @NSManaged public func removeFromChildren(at idx: Int)

    @objc(insertChildren:atIndexes:)
    @NSManaged public func insertIntoChildren(_ values: [ButtonOption], at indexes: NSIndexSet)

    @objc(removeChildrenAtIndexes:)
    @NSManaged public func removeFromChildren(at indexes: NSIndexSet)

    @objc(replaceObjectInChildrenAtIndex:withObject:)
    @NSManaged public func replaceChildren(at idx: Int, with value: ButtonOption)

    @objc(replaceChildrenAtIndexes:withChildren:)
    @NSManaged public func replaceChildren(at indexes: NSIndexSet, with values: [ButtonOption])

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: ButtonOption)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: ButtonOption)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSOrderedSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSOrderedSet)

}

extension ButtonOption : Identifiable {

}
