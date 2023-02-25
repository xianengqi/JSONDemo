//
//  AddSkuView.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/23.
//

import SwiftUI

struct AddSkuView: View {
  @State private var color = ""
  @State private var price: Double = 0
  @State private var size = ""
  @State private var stock: Double = 0
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) var dismiss

  var body: some View {
    Form {
      Section {
        TextField("Color", text: $color)
        TextField("Price", value: $price, formatter: NumberFormatter())
        TextField("Size", text: $size)
        TextField("Stock", value: $stock, formatter: NumberFormatter())

        Button(action: {
          CoreDataStack().add(color: color, price: price, size: size, stock: stock, context: viewContext)
          CoreDataStack().checkColor(color: color, context: viewContext)
          //          print(newSku)
          dismiss()
        }, label: {
          Text("Add")
        })
      }
    }
  }
}

struct AddSkuView_Previews: PreviewProvider {
  static var previews: some View {
    AddSkuView()
  }
}
