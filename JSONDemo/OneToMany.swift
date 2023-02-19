//
//  OneToMany.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/19.
//

import SwiftUI

struct OneToMany: View {
  @Environment(\.managedObjectContext) private var context
  
  @FetchRequest(entity: Club.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: \Club.clubName, ascending: true)])
  private var clubs: FetchedResults<Club>
  
    var body: some View {
      List {
        ForEach(clubs) { club in
          Section(header: HStack {
            Text("\(club.clubName!) (顾问: \(club.teacher!))")
          }) {
            VStack(alignment: .leading) {
              ForEach(studentArray(club.students), id: \.self) { student in
                Text("\(student.sid!) \(student.name!)")
              }
            }
          }
        }
      }
      .onAppear {
        registSampleData(context: context)
      }
    }
  
  /// 由于显示与 Student 表的关系的 club.students 是一个 NSSet 类型，它是一个无序的集合类，下面的函数将其转换为一个 Students 数组。
  /// NSSet? -> [Student]变换
  private func studentArray(_ students: NSSet?) -> [Student] {
    let set = students as? Set<Student> ?? []
    return set.sorted {
      $0.sid! < $1.sid!
    }
  }
}

//struct OneToMany_Previews: PreviewProvider {
//    static var previews: some View {
//        OneToMany()
//    }
//}
