//
//  JSONDemoApp.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/17.
//

import SwiftUI

@main
struct JSONDemoApp: App {
  
//  let persistenceController = PersistenceController.shared
  
  @StateObject private var coredataStack = CoreDataStack()
  
    var body: some Scene {
        WindowGroup {
//            ContentView()
//          OneToOneSearchSort()
//          OneToMany()
//          OneToOneView()
          ProductStockView()
            .environment(\.managedObjectContext, coredataStack.container.viewContext)
        }
    }
}
