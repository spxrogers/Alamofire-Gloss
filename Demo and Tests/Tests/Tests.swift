
@testable import Demo
import Quick
import Nimble
import Alamofire
import Gloss
import Alamofire_Gloss

class ResponseGlossSpec: QuickSpec {
  override func spec() {
    let personUrl = "http://srogers.net/rest/person.json"
    let peopleUrl = "http://srogers.net/rest/people.json"
    let badFormatUrl = "http://srogers.net/rest/bad_format.json"
    let badPersonUrl = "http://srogers.net/rest/bad_person.json"
  
    // standard
    it("handles a core object request") {
      let steven = Person(json: ["name": "steven rogers", "age": 21])!
      var equal = false
      
      waitUntil(timeout: 5) { done in
        Alamofire.request(personUrl).responseObject(Person.self) { (response) in
          switch response.result {
          case .success(let person):
            equal = steven == person
          case .failure(_):
            equal = false
          }
          done()
        }
      }
      expect(equal).to(beTruthy())
    }
    
    it("handles a core array request") {
      let steven = Person(json: ["name": "steven rogers", "age": 21])!
      let john = Person(json: ["name": "john doe"])!
      let people = [steven, john]
      var equal = false
      
      waitUntil(timeout: 5) { done in
        Alamofire.request(peopleUrl).responseArray(Person.self) { (response) in
          switch response.result {
          case .success(let responsePeople):
            equal = people == responsePeople
          case .failure(_):
            equal = false
          }
          done()
        }
      }
      expect(equal).to(beTruthy())
    }
    
    // bad requests
    it("handles a core object missing required gloss fields") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        Alamofire.request(badPersonUrl).responseObject(Person.self) { (response) in
          switch response.result {
          case .success(_):
            failedWhenExpected = false
          case .failure(_):
            failedWhenExpected = true
          }
          done()
        }
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core object invalid format") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        Alamofire.request(badFormatUrl).responseObject(Person.self) { (response) in
          switch response.result {
          case .success(_):
            failedWhenExpected = false
          case .failure(_):
            failedWhenExpected = true
          }
          done()
        }
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core array invalid format") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        Alamofire.request(badPersonUrl).responseArray(Person.self) { (response) in
          switch response.result {
          case .success(_):
            failedWhenExpected = false
          case .failure(_):
            failedWhenExpected = true
          }
          done()
        }
      }
      expect(failedWhenExpected).to(beTruthy())
    }
  }
}
