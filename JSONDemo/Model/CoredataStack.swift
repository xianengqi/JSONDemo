//
//  CoredataStack.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/19.
//
import CoreData
import Foundation

class CoreDataStack: ObservableObject {
  let container = NSPersistentContainer(name: "Model")
  
  init() {
    container.loadPersistentStores { _, error in
      if let error = error {
        print("Unresolved error \(error), \(error.localizedDescription)")
      }
      
    }
  }
  
  func save(context: NSManagedObjectContext) {
    do {
      try context.save()
      print("Data saved")
    } catch {
      print("Error saving managed object context: \(error)")
    }
  }
  
  func add(color: String, price: Double, size: String, stock: Double, context: NSManagedObjectContext) {
    let newTask = Sku(context: context)
    newTask.sku_id = UUID()
    newTask.color = color
    newTask.price = price
    newTask.size = size
    newTask.stock = stock
    save(context: context)
  }
  
  func edit(editModel: Sku, color: String, price: Double, stock: Double, context: NSManagedObjectContext) {
    editModel.color = color
    editModel.price = price
    editModel.stock = stock
    
    save(context: context)
  }
  
  // 当添加的color是重复的时候，排除掉
  func checkColor(color: String, context: NSManagedObjectContext) -> Bool {
    let request: NSFetchRequest<Sku> = Sku.fetchRequest()
    let predicate = NSPredicate(format: "color == %@", color)
    request.predicate = predicate
    do {
      let result = try context.fetch(request)
      if result.count > 0 {
        return false
      } else {
        return true
      }
    } catch {
      print("Error fetching data from context \(error)")
      return false
    }
  }
  
  
}

// struct PersistenceController {
//    static let shared = PersistenceController()
//
//    static var preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//
//      let newTask = Task(context: viewContext)
//      newTask.timestamp = Date()
//      newTask.checked = false
//      newTask.name = "示例数据"
//
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()
//
//    let container: NSPersistentContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "Model")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//    }
// }
