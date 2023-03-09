//
//  ColorEntity+CoreDataProperties.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/3/3.
//
//

import CoreData
import Foundation

public extension ColorEntity {
  @nonobjc class func fetchRequest() -> NSFetchRequest<ColorEntity> {
    return NSFetchRequest<ColorEntity>(entityName: "ColorEntity")
  }

  @NSManaged var colors: [String]
  @NSManaged var sizeClothes: [String]
  @NSManaged var createdAt: Date?
  @NSManaged var selectedColors: NSArray?
  @NSManaged var isSelected: Bool
}

extension ColorEntity: Identifiable {}

extension ColorEntity {
  func removeFromSizeClothes(at index: Int) {
    var sizes = sizeClothes 
    sizes.remove(at: index)
    sizeClothes = sizes

    willChangeValue(forKey: "sizeClothes")
    didChangeValue(forKey: "sizeClothes")
  }
}
