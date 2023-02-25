//
//  FilteredList.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/25.
//

import CoreData
import SwiftUI

struct FilteredList<T: NSManagedObject, Content: View>: View {
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest var fetchRequest: FetchedResults<T>
  let content: (T) -> Content

  var body: some View {
    List {
      ForEach(fetchRequest, id: \.self) { item in
        self.content(item)
      }
      .onDelete(perform: deleteItems)
    }
  }

  init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
    _fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [], predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue))
    self.content = content
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { fetchRequest[$0] }.forEach(viewContext.delete)

      do {
        try viewContext.save()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
