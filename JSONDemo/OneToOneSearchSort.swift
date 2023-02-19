//
//  OneToOneSearchSort.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/19.
//

import SwiftUI

struct OneToOneSearchSort: View {
  
  @Environment(\.managedObjectContext) private var context
  
  let classes = ["A", "B"]
  @State private var selectionClass = 0
  
  var body: some View {
    VStack {
      Picker(selection: $selectionClass) {
        ForEach(0..<classes.count) { index in
          Text(classes[index])
        }
      } label: {
        Text("类别名称")
      }
      .pickerStyle(SegmentedPickerStyle())
      
      StudentsList(nameOfClass: classes[selectionClass])
    }
    .onAppear{
      registSampleData(context: context)
    }
  }
  
}

struct OneToOneSearchSort_Previews: PreviewProvider {
    static var previews: some View {
        OneToOneSearchSort()
    }
}
