//
//  Sorting.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/24.
//

import Foundation

struct Sorting: Hashable, Identifiable {
  
  let id: Int
  let title: String
  let descriptors: [SortDescriptor<Sku>]
  
  static let sorts: [Sorting] = [

    Sorting(
      id: 0,
      title: "Date | Ascending",
      // 3
      descriptors: [
        SortDescriptor(\Sku.color, order: .forward),
        SortDescriptor(\Sku.price, order: .forward)
      ])
  ]

  static var `default`: Sorting { sorts[0] }
  
}
