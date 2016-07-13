//
//  Person.swift
//  Demo
//
//  Created by steven rogers on 7/12/16.
//  Copyright © 2016 steven rogers. All rights reserved.
//

import Foundation
import Gloss

struct Person: Decodable {
  
  let name: String
  let age: Int?
  
  init?(json: JSON) {
    guard let name: String = "name" <~~ json
      else { return nil }
    
    self.name = name
    self.age = "age" <~~ json
  }
}

// MARK: Equatable for unit tests

extension Person: Equatable { }
func ==(lhs: Person, rhs: Person) -> Bool {
  return lhs.name == rhs.name && lhs.age == rhs.age
}
