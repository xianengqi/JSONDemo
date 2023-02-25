//
//  Sku+CoreDataProperties.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/25.
//
//

import Foundation
import CoreData


extension Sku {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sku> {
        return NSFetchRequest<Sku>(entityName: "Sku")
    }

    @NSManaged public var color: String?
    @NSManaged public var price: Double
    @NSManaged public var size: String?
    @NSManaged public var sku_id: UUID?
    @NSManaged public var stock: Double
    @NSManaged public var spu: Spu?
  
  var wrappedColor: String {
    color ?? "Unknow"
  }
  
  var wrappedSize: String {
    size ?? "Unknow"
  }

}

extension Sku : Identifiable {

}
