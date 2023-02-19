//
//  RegistSampleData.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/19.
//

import CoreData

func registSampleData(context: NSManagedObjectContext) {
  // MARK: - CoreData: Entity -> Student

  let studentList = [
    //    ["001", "小明", "2023/04/16", "3", "A", "钢琴 "],
//    ["002", "小张", "2023/02/03", "0", "B", "小提琴"],
//    ["003", "小伍", "2023/08/17", "10", "B", "口风琴"],
//    ["004", "小花", "2023/02/22", "7", "A", "鼓"],
//    ["005", "小程", "2023/02/17", "5", "A", "古筝"],
    ["001", "カピバラ", "2010/04/16", "3", "A", "バスケット"],
    ["002", "アライグマ", "2011/02/06", "0", "B", "サッカー"],
    ["003", "カイウサギ", "2010/04/08", "10", "B", ""],
    ["004", "ハクビシン", "2010/12/21", "7", "A", "吹奏楽"],
    ["005", "ワオキツネザル", "2010/9/20", "5", "A", "サッカー"],
  ]
  
  // MARK: - CoreData: Entity -> Club

  let clubList = [
    ["バスケット", "ツキノワグマ"],
    ["サッカー", "ベンガルトラ"],
    ["陸上", "ニホンジカ"],
    ["吹奏楽", "アカカンガルー"],
  ]
  
  /// Student Delete 这是查找Student表并删除所有记录的过程。
  let fetchRequestStudent = NSFetchRequest<NSFetchRequestResult>()
  fetchRequestStudent.entity = Student.entity()
  let students = try? context.fetch(fetchRequestStudent) as? [Student]
  for student in students! {
    context.delete(student)
  }
  
  /// Club Delete 这是查找Club表并删除所有记录的过程。
  let fetchRequestClub = NSFetchRequest<NSFetchRequestResult>()
  fetchRequestClub.entity = Club.entity()
  let clubs = try? context.fetch(fetchRequestClub) as? [Club]
  for club in clubs! {
    context.delete(club)
  }
  
  /// Club 登记
  for club in clubList {
    let newClub = Club(context: context)
    newClub.clubName = club[0] // 俱乐部名称
    newClub.teacher = club[1] // 担任
  }
  
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy/M/d"
  
  /// Student 登记
  for student in studentList {
    let newStudent = Student(context: context)
    newStudent.sid = student[0]
    newStudent.name = student[1]
    newStudent.birthday = dateFormatter.date(from: student[2])!
    newStudent.absentDays = Int16(student[3])!
    newStudent.nameOfClass = student[4]
    newStudent.sortClub = student[5]
    
    /// 关系关联设定
    fetchRequestClub.predicate = NSPredicate(format: "clubName = %@", student[5])
    let result = try? context.fetch(fetchRequestClub) as? [Club]
    if result!.count > 0 {
      ///  Student -> Club关系
      newStudent.club = result![0]
      /// Club -> Student 关系
//      result![0].addToStudents(newStudent)
    }
  }
  
  try? context.save()
}
