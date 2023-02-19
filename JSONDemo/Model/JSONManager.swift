//
//  JSONManager.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/17.
//

import Foundation

// app.qucktype.io

// MARK: - WelcomeElement

struct Person: Codable {
  var firstName, surname, gender: String
  var age: Int
  var address: Address
  var phoneNumbers: [PhoneNumber]
  
  static let allPeople: [Person] = Bundle.main.decode(file: "example.json")
  static let samplePerson: Person = allPeople[0]
}

// MARK: - Address

struct Address: Codable {
  var streetAddress, city, state, postalCode: String
}


struct PhoneNumber: Codable {
  var type, number: String
}

extension Bundle {
  func decode<T: Decodable>(file: String) -> T {
    guard let url = self.url(forResource: file, withExtension: nil) else {
      fatalError("Could not find \(file) in the project!")
    }
    
    guard let data = try? Data(contentsOf: url) else {
      fatalError("Could not load \(file) in the project!")
    }
    
    let decoder = JSONDecoder()
    
    guard let loadedData = try? decoder.decode(T.self, from: data) else {
      fatalError("Could not decoder \(file) in the project!")
    }
    
    return loadedData
  }
}
