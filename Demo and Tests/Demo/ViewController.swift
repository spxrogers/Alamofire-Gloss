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
  
  private func text(str: String) {
    resultsLabel.text = str
  }
  
  @IBAction func mapPersonPressed(sender: UIButton) {
    Alamofire.request(.GET, personUrl, parameters: nil).responseObject(Person.self) { (response) in
      switch response.result {
      case .Success(let person):
        self.text("Found person: \(person)")
      case .Failure(let error):
        self.text("Error'd: \(error)")
      }
    }
  }
  
  @IBAction func mapPeoplePressed(sender: UIButton) {
    Alamofire.request(.GET, peopleUrl, parameters: nil).responseArray(Person.self) { (response) in
      switch response.result {
      case .Success(let people):
        self.text("Found people: \(people)")
      case .Failure(let error):
        self.text("Error'd: \(error)")
      }
    }
  }
}

