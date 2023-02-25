//
//  DetailView.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/17.
//

import SwiftUI

struct DetailView: View {
  func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var dict = [Int: Int]()
    for (index, num) in nums.enumerated() {
      if let pairIndex = dict[target - num] {
        return [pairIndex, index]
      }
      dict[num] = index
    }
    return []
  }



 

  var person: Person

  var body: some View {
    VStack {
      Text("\(person.firstName) \(person.surname)")
        .bold()
      Text("\(person.phoneNumbers[0].number)")
      Text("\(person.address.streetAddress)")
      Text("\(person.address.city)")
    }
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(person: Person.samplePerson)
  }
}

class NotificationManager: ObservableObject {
  func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var dict = [Int: Int]()
    for (index, num) in nums.enumerated() {
      if let pairIndex = dict[target - num] {
        return [pairIndex, index]
      }
      dict[num] = index
    }
    return []
  }


}



