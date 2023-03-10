//
//  DetailExample.swift
//  JSONDemo
//
//  Created by 夏能启 on 2023/3/10.
//

import CoreData
import SwiftUI

@available(iOS 16.4, *)
struct DetailExample: View {
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
    entity: ProductEntity.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \ProductEntity.name, ascending: true)],
    predicate: NSPredicate(format: "name != nil AND name != ''"),
    animation: .default
  )
  private var fetchBrandName: FetchedResults<ProductEntity>

  // 新增一个存储数据库查询结果的私有属性
//  @State private var products: [ProductEntity] = []

  var body: some View {
    NavigationView {
      ZStack {
        ScrollView {
          header()
        }
        bottom()
      }
//      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .navigationBarBackButtonHidden(true)
    }
//    .navigationViewStyle(.stack)

    // 在onAppear中更新查询结果
//      .onAppear {
//        products = Array(fetchBrandName)
//      }
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
        Divider()
      }
    }
    .offset(y: 30)
  }

  @ViewBuilder
  private func bottom() -> some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        NavigationLink(destination: AddView()) {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundColor(.blue)
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding()
      }
    }
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

// struct DetailExample_Previews: PreviewProvider {
//  static var previews: some View {
//    DetailExample().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//  }
// }
