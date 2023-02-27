//
//  TestSample.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/22.
//

import Combine
import CoreData
import Foundation
import SwiftUI
import UIKit
// 对于商品来说，通常会创建一个SPU（ 标准产品单位）以及 SKU（ 库存量单位 ）两个结构。
//
//   用 Core Data 举例的话，就是两个 Entity（实体 ）
//
//  例如：
//   SPU：
//      title: 连衣裙
//      description：碎花棉质
//      sku：对应的 sku 数据（ 这里应该是 one to many ）
//
//   SKU:
//      price:价格
//     color: 颜色
//     size: 尺寸
//     stock: 库存
//     spu: 对应的 SPU 数据 （ 在 Core Data 中创建关系 ，这里应该是 many to one ）
//
//     等等
//
// 在这个设定视图中，通过 predicate （ 谓词 ），获取特定 SPU 商品的 SKU 数据。
//
// 例如 上面的颜色 （ 可以过滤重复数据方式获取 ）
// 下面的 size 数量，则分别显示于颜色对应的 库存数量，谓词为 spu、color、size
//
// 每次点击调整库存的按钮，都将通过 Core Data 修改数据库中对应的数据。
// 数据变化，反过来会通过 FetchRequest 来更新视图，从而实现响应式的更新。
//
// 具体该如何设计，你应根据实际需要仔细考虑，然后将其转换成 Core Data 的表现形式
struct ProductStockView: View {
  @Environment(\.managedObjectContext) var viewContext
  
  @State private var isShow = false
  
  @State private var isSortColor = ""
  
  @FetchRequest(sortDescriptors: [SortDescriptor(\.sku_id)]) var dayss: FetchedResults<Sku>
  
  @FetchRequest(
    entity: Sku.entity(),
    sortDescriptors: [
      NSSortDescriptor(keyPath: \Sku.sku_id, ascending: true),
//      NSSortDescriptor(keyPath: \Sku.size, ascending: true)
    ]
//    predicate: NSPredicate(format: "spu == %@", "连衣裙")
  ) var skus: FetchedResults<Sku>
  
  @State private var showingAddView = false
  
  func stock(sku: Sku) -> Int {
    Int(sku.stock)
  }
  
  func price(sku: Sku) -> Int {
    Int(sku.price)
  }
  
  func updateStock(sku: Sku, stock: Int) {
    viewContext.performAndWait {
      sku.stock = Double(stock)
      try? viewContext.save()
    }
  }
  
  // 库存减去1
  func reduceStock(sku: Sku) {
    updateStock(sku: sku, stock: stock(sku: sku) - 1)
  }
  
  private func deleteClothes(offsets: IndexSet) {
    withAnimation {
      offsets.map { skus[$0] }.forEach(viewContext.delete)
      CoreDataStack().save(context: viewContext)
    }
  }
  
  // 库存总计
  
  var body: some View {
    NavigationStack {
      VStack {
        Grid {
          GridRow {
            ForEach(Array(Set(skus.map(\.color))), id: \.self) { color in
              VStack {
                Text("\(color ?? "无")")
                  .onTapGesture {
                    self.isSortColor = color ?? ""
                    print("\(color ?? "wu")")
                  }
                Text("尺码\(skus.filter { $0.color == color }.count)个")
                // 库存总计
                Text("库存\(skus.filter { $0.color == color }.reduce(0) { $0 + Int($1.stock) })")
              }
            }
          }
        }
      }
      
      VStack {
        FilteredList(filterKey: "color", filterValue: isSortColor) { (skuSort: Sku) in
          Section(header: Text("\(skuSort.wrappedColor)")) {
            VStack {
              HStack {
                Text("\(skuSort.wrappedSize)")
                
                Spacer()
//                Button(action: {
//                  // 删除
//                  viewContext.delete(skuSort)
//                  try? viewContext.save()
//                }, label: {
//                  Text("删除")
//                })
              }
              HStack {
                Text("价格\(price(sku: skuSort))")
                Spacer()
                // 添加计数器
                Stepper(value: Binding(
                  get: { stock(sku: skuSort) },
                  set: { updateStock(sku: skuSort, stock: $0) }
                ), in: 0 ... 1000) {
                  Text("库存\(stock(sku: skuSort))")
                }
              }
            }
          }
        }
      }

      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            showingAddView.toggle()
          } label: {
            Label("Add Day", systemImage: "plus.circle")
          }
        }
      }
      .sheet(isPresented: $showingAddView, content: {
        AddSkuView()
      })
      .listStyle(GroupedListStyle())
      .navigationTitle("库存")
    }
    .navigationViewStyle(.stack)
  }
}
