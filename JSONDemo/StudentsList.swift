//
//  StudentsList.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/19.
//

import SwiftUI

struct StudentsList: View {
  var fetchRequest: FetchRequest<Student>
  
  init(nameOfClass: String) {
    fetchRequest = FetchRequest<Student>(
      entity: Student.entity(),
      sortDescriptors: [NSSortDescriptor(keyPath: \Student.sid, ascending: true)],
      predicate: NSPredicate(format: "nameOfClass == %@", nameOfClass),
      animation: .default
    )
  }
  
  var body: some View {
    List {
      ForEach(fetchRequest.wrappedValue, id: \.self) { student in
        Section(header: HStack {
          Text("\(student.sid!)")
          Text("\(student.name!)")
        }) {
          VStack(alignment: .leading) {
            Text("年份: \(student.birthday!, style: Text.DateStyle.date)")
            Text("旷课次数: \(student.absentDays)")
            Text("分类: \(student.nameOfClass!)")
            Text("活动: \(student.sortClub!)")
          }
        }
      }
    }
  }
}

//struct StudentsList_Previews: PreviewProvider {
//  static var previews: some View {
//    StudentsList()
//  }
//}
