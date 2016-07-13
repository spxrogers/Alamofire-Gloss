//
//  Response+Gloss.swift
//
//  Created by steven rogers on 7/12/16.
//  Copyright (c) 2016 Steven Rogers
//

import Alamofire
import Gloss

/// Domain constant for constucting an NSError
public let AlamoFireGloss_ErrDomain = "Alamofire+Gloss"

/// Code constant for constucting an NSError
public let AlamoFireGloss_ErrCode = -1

public extension Alamofire.Request {
 
  /// Creates a response serializer to map Response Data into an object that implements the Decodable or Glossy protocol.
  static public func GlossyObjectResponseSerializer<T: Decodable>() -> Alamofire.ResponseSerializer<T, NSError> {
    return Alamofire.ResponseSerializer { _, resp, data, error in
      guard error == nil
        else { return .Failure(error!) }
      
      guard
        let dat = data,
        let json = mapJSON(dat) as? JSON,
        let result = T(json: json)
      else {
        let errz = NSError(domain: AlamoFireGloss_ErrDomain, code: AlamoFireGloss_ErrCode, userInfo: ["data": resp ?? "nil"])
        return .Failure(errz)
      }
      
      return .Success(result)
    }
  }
  
  /// Creates a response serializer to map Response Data into an array of objects that implements the Decodable or Glossy protocol.
  static public func GlossyArrayResponseSerializer<T: Decodable>() -> Alamofire.ResponseSerializer<[T], NSError> {
    return Alamofire.ResponseSerializer { _, resp, data, error in
      guard error == nil
        else { return .Failure(error!) }
      
      guard
        let dat = data,
        let json = mapJSON(dat) as? [JSON]
      else {
        let errz = NSError(domain: AlamoFireGloss_ErrDomain, code: AlamoFireGloss_ErrCode, userInfo: ["data": resp ?? "nil"])
        return .Failure(errz)
      }
      
      let result = [T].fromJSONArray(json)
      return .Success(result)
    }
  }
  
  /// The response handler for object-mapping that is called once the Alamofire request completes.
  public func responseObject<T: Decodable>(type: T.Type, completionHandler: Alamofire.Response<T, NSError> -> Void) -> Self {
    return response(responseSerializer: Alamofire.Request.GlossyObjectResponseSerializer(), completionHandler: completionHandler)
  }
  
  /// The response handler for array-mapping that is called once the Alamofire request completes.
  public func responseArray<T: Decodable>(type: T.Type, completionHandler: Alamofire.Response<[T], NSError> -> Void) -> Self {
    return response(responseSerializer: Alamofire.Request.GlossyArrayResponseSerializer(), completionHandler: completionHandler)
  }
}

private func mapJSON(data: NSData) -> AnyObject? {
  do {
    return try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
  } catch {
    return nil
  }
}