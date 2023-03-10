//
//  DetailExample.swift
//  JSONDemo
//
//  Created by 夏能启 on 2023/3/10.
//

import SwiftUI
import CoreData

struct DetailExample: View {
  
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
    entity: ProductEntity.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \ProductEntity.name, ascending: true)],
    animation: .default
  )
  private var fetchBrandName: FetchedResults<ProductEntity>
  
  var body: some View {
    ScrollView {
      header()
    }
  }

  @ViewBuilder
  private func header() -> some View {
    VStack {
      ForEach(fetchBrandName, id: \.self) { item in
        HStack {
          Color.clear.overlay {
            Text(item.name ?? "")
          }
          Color.clear
          Color.clear.overlay {
            Image(systemName: "chevron.right")
          }
        }
        .padding()
        // 整行点击状态
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
        .onTapGesture {
          print("点击： \(item.name ?? "")")
        }
        .contextMenu {
          Button {
            deleteProduct(product: item)
          } label: {
            Label("删除", systemImage: "trash.fill")
          }
        }
      }
    }
    .offset(y: 30)
  }

  private func deleteProduct(product: ProductEntity) {
    viewContext.delete(product)
    saveContext()
  }

  private func saveContext() {
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}

//struct DetailExample_Previews: PreviewProvider {
//  static var previews: some View {
//    DetailExample().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//  }
//}
