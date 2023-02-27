//
//  FirstExample.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/27.
//

import SwiftUI
import Flow

struct FirstExample: View {
  // 假颜色数据
  let items = ["red", "green", "blue", "yellow", "orange", "purple", "pink",
               "red", "green", "blue", "yellow", "orange", "purple", "pink"]
  
  

  var body: some View {
    ScrollView {
      HFlow(itemSpacing: 14, rowSpacing: 10) {
        ForEach(items, id: \.description) { item in
          Text(item)
            .background(.red)
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    FirstExample()
  }
}
