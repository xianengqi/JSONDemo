//
//  JSONDemoApp.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/17.
//

import SwiftUI

@main
struct JSONDemoApp: App {
  
  let persistenceController = PersistenceController.shared
  
    var body: some Scene {
        WindowGroup {
//            ContentView()
          OneToOneSearchSort()
//          OneToMany()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
