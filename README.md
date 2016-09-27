Alamofire-Gloss
============
[![CocoaPods](https://img.shields.io/cocoapods/v/Alamofire-Gloss.svg)](http://cocoapods.org/pods/Alamofire-Gloss)
[![Carthage
compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

[Gloss](https://github.com/hkellaway/Gloss) bindings for [Alamofire](https://github.com/Alamofire/Alamofire) for easy-peasy JSON serialization.

# Installation

### CocoaPods

Add to your Podfile:

```ruby
pod 'Alamofire-Gloss'
```

### Carthage

```ruby
github "spxrogers/Alamofire-Gloss"
```

`Alamofire-Gloss` lists `Alamofire` and `Gloss` as explicit Carthage dependencies, so it's only
necessary to list `Alamofire-Gloss` in your Cartfile and it will pull down all
three libraries. Copy & Link generated frameworks as normal.

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
Alamofire.request(personUrl).responseObject(Person.self) { (response) in
  switch response.result {
  case .success(let person):
    print("Found person: \(person)")
  case .failure(let error):
    print("Error'd: \(error)")
  }
}
```

## 2. Example – mapArray


```swift
Alamofire.request(peopleUrl).responseArray(Person.self) { (response) in
  switch response.result {
  case .success(let people):
    print("Found people: \(people)")
  case .failure(let error):
    print("Error'd: \(error)")
  }
}
```

# Contributing

Issues and pull requests are welcome!

# Author

Steven Rogers [@spxrogers](https://twitter.com/spxrogers)

# Thanks ... 

... to [Harlan Kellaway](http://harlankellaway.com) for creating Gloss, my preferred JSON library :)

... to the [Alamofire](https://github.com/Alamofire/Alamofire) (+[AFNetworking](https://github.com/AFNetworking/AFNetworking)) team for paving the way of Networking in iOS.

# License

Alamofire-Gloss is released under an MIT license. See LICENSE for more information.

![Smile for a permissive license.](https://media.giphy.com/media/12Rv3g5EveQwHS/giphy.gif)
