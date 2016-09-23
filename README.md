Alamofire-Gloss
============

[Gloss](https://github.com/hkellaway/Gloss) bindings for [Alamofire](https://github.com/Alamofire/Alamofire) for easy-peasy JSON serialization.

# Installation

### CocoaPods

Add to your Podfile:

```ruby
pod 'Alamofire-Gloss', :git => 'https://github.com/jpunz/Alamofire-Gloss.git'
```

# Usage

### Define your Model

Create a `Class` or `Struct` which implements the `Decodable` (or `Glossy`) protocol.

```swift
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
```

### API

```swift
responseObject()
responseArray()
```

## 1. Example – mapObject


```swift
Alamofire.request(.GET, personUrl, parameters: nil).responseObject(Person.self) { (response) in
  switch response.result {
  case .Success(let person):
    print("Found person: \(person)")
  case .Failure(let error):
    print("Error'd: \(error)")
  }
}
```

## 2. Example – mapArray


```swift
Alamofire.request(.GET, peopleUrl, parameters: nil).responseArray(Person.self) { (response) in
  switch response.result {
  case .Success(let people):
    print("Found people: \(people)")
  case .Failure(let error):
    print("Error'd: \(error)")
  }
}
```

# Contributing

Issues and pull requests are welcome!

# Author

Steven Rogers [@spxrogers](https://twitter.com/spxrogers)
Updated by jpunz

# Thanks ... 

... to [Harlan Kellaway](http://harlankellaway.com) for creating Gloss, my preferred JSON library :)

... to the [Alamofire](https://github.com/Alamofire/Alamofire) (+[AFNetworking](https://github.com/AFNetworking/AFNetworking)) team for paving the way of Networking in iOS.

# License

Alamofire-Gloss is released under an MIT license. See LICENSE for more information.
