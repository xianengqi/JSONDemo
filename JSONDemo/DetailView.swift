//
//  DetailView.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/17.
//

import SwiftUI

struct DetailView: View {
  
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
