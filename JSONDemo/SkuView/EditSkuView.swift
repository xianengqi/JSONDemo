//
//  EditSkuView.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/24.
//

import SwiftUI

struct EditSkuView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @Environment(\.dismiss) var dismiss
  
  var editModelFetch: FetchedResults<Sku>.Element
  
  @State private var color = ""
  @State private var price: Double = 0
  @State private var stock: Double = 0
  
  var body: some View {
    VStack {
      Form {
        Section {
          TextField("\(editModelFetch.color!)", text: $color)
            .onAppear {
              color = editModelFetch.color!
              price = editModelFetch.price
              stock = editModelFetch.stock
            }
          
          TextField("Stock", value: $stock, formatter: NumberFormatter())
          
          HStack {
            Spacer()
            Button("Update") {
              CoreDataStack().edit(editModel: editModelFetch, color: color, price: price, stock: stock, context: managedObjectContext)
              dismiss()
            }
            Spacer()
          }
        }
      }
    }
  }
}
