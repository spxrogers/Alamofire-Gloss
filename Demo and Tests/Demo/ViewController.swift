//
//  ViewController.swift
//  Demo
//
//  Created by steven rogers on 7/12/16.
//  Copyright © 2016 steven rogers. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import Alamofire_Gloss

class ViewController: UIViewController {

  @IBOutlet var resultsLabel: UILabel!
  
  let personUrl = "http://srogers.net/rest/person.json"
  let peopleUrl = "http://srogers.net/rest/people.json"
  
  fileprivate func text(_ str: String) {
    resultsLabel.text = str
  }
  
  @IBAction func mapPersonPressed(_ sender: UIButton) {
    // Alamofire requests default to GET (.get) HTTP methods
    Alamofire.request(personUrl).responseObject(Person.self) { (response) in
      switch response.result {
      case .success(let person):
        self.text("Found person: \(person)")
      case .failure(let error):
        self.text("Error'd: \(error)")
      }
    }
  }
  
  @IBAction func mapPeoplePressed(_ sender: UIButton) {
    // Alamofire requests default to GET (.get) HTTP methods
    Alamofire.request(peopleUrl).responseArray(Person.self) { (response) in
      switch response.result {
      case .success(let people):
        self.text("Found people: \(people)")
      case .failure(let error):
        self.text("Error'd: \(error)")
      }
    }
  }
}
