//
//  ColorEntity+CoreDataProperties.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/3/3.
//
//

import Foundation
import CoreData


extension ColorEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ColorEntity> {
        return NSFetchRequest<ColorEntity>(entityName: "ColorEntity")
    }

    @NSManaged public var colors: [String]
    @NSManaged public var createdAt: Date?
    @NSManaged public var selectedColors: NSArray?
    @NSManaged public var isSelected: Bool
}

extension ColorEntity : Identifiable {

}
