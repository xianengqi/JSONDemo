//
//  JSONDemoApp.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/17.
//

import SwiftUI

@available(iOS 16.4, *)
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
//          ProductStockView()
      AddView()
        .environment(\.managedObjectContext, coredataStack.container.viewContext)
    }
  }
}

// extension UserDefaults {
//  static let selectedColorsKey = "SelectedColors"
// }
