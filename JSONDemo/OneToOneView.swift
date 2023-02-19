//
//  OneToOneView.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/19.
//

import SwiftUI

struct OneToOneView: View {
  @Environment(\.managedObjectContext) private var context

  @FetchRequest(entity: Student.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: \Student.sid, ascending: true)], // 指定排序顺序
                predicate: NSPredicate(format: "nameOfClass == %@", "A"), // 指定提取条件
                animation: .default // 动画
  )
  private var students: FetchedResults<Student>

  var body: some View {
    List {
      ForEach(students, id: \.self) { student in
        Section(header: HStack {
          Text("\(student.sid!) \(student.name!)")
        }) {
          VStack(alignment: .leading) {
            Text("年份：\(student.birthday!, style: Text.DateStyle.date)")
            Text("旷课天数: " + String(student.absentDays))
            Text("类别: \(student.nameOfClass!)")
            HStack {
              Text("分会活动 ")
              if let club = student.club {
                Text("\(club.clubName!) (顾问: \(club.teacher!))")
                  .foregroundColor(.red)
              }
            }
          }
        }
      }
    }
    .onAppear {
      /// 在显示视图时执行初始数据注册过程。
      registSampleData(context: context)
    }
  }
}

struct OneToManyView_Previews: PreviewProvider {
  static var previews: some View {
    OneToOneView()
  }
}
