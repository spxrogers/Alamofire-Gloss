//
//  Response+Gloss.swift
//
//  Created by steven rogers on 7/12/16.
//  Copyright (c) 2016 Steven Rogers
//

import Alamofire
import Gloss

enum AlamofireGlossError: Error {
  case jsonDecoding(rootCause: Any)
  case glossyInit(inputJson: JSON)
  case glossyArrayInit(inputJson: [JSON])
}

// MARK: – Base Alamofire.Request

public extension Request {
  
  // MARK: - Object
  
  public static func serializeReponseGlossyObject<T: JSONDecodable>(type: T.Type,
                                                                    response: HTTPURLResponse?,
                                                                    data: Data?,
                                                                    error: Error?) -> Result<T> {
    guard error == nil else { return .failure(error!) }
    guard let validData = data, validData.count > 0 else {
      return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
    }

    let maybeJson = mapJSON(validData)
    guard let json = maybeJson as? JSON else {
      return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error:
        AlamofireGlossError.jsonDecoding(rootCause: maybeJson))))
    }

    guard let result = T(json: json) else {
      return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error:
        AlamofireGlossError.glossyInit(inputJson: json))))
    }
    return .success(result)
  }
  
  // MARK: - Array
  
  public static func serializeReponseGlossyArray<T: JSONDecodable>(type: T.Type,
                                                                   response: HTTPURLResponse?,
                                                                   data: Data?,
                                                                   error: Error?) -> Result<[T]> {
    guard error == nil else { return .failure(error!) }
    guard let validData = data, validData.count > 0 else {
      return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
    }

    let maybeJson = mapJSON(validData)
    guard let jsonArray = maybeJson as? [JSON] else {
      return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error:
        AlamofireGlossError.jsonDecoding(rootCause: maybeJson))))
    }

    guard let result = [T].from(jsonArray: jsonArray) else {
      return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error:
        AlamofireGlossError.glossyArrayInit(inputJson: jsonArray))))
    }
    return .success(result)
  }
}

// MARK: – Alamofire.DataRequest

public extension DataRequest {
  
  // MARK: - Object
  
  public static func glossyObjectResponseSerializer<T: JSONDecodable>(type: T.Type) -> DataResponseSerializer<T> {
    return DataResponseSerializer { _, response, data, error in
      return Request.serializeReponseGlossyObject(type: T.self, response: response, data: data, error: error)
    }
  }
  
  @discardableResult
  public func responseObject<T: JSONDecodable>(_ type: T.Type,
                                               queue: DispatchQueue? = nil,
                                               completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
    return response(queue: queue,
                    responseSerializer: DataRequest.glossyObjectResponseSerializer(type: T.self),
                    completionHandler: completionHandler)
  }
  
  // MARK: - Array
  
  public static func glossyArrayResponseSerializer<T: JSONDecodable>(type: T.Type) -> DataResponseSerializer<[T]> {
    return DataResponseSerializer { _, response, data, error in
      return Request.serializeReponseGlossyArray(type: T.self, response: response, data: data, error: error)
    }
  }
  
  @discardableResult
  public func responseArray<T: JSONDecodable>(_ type: T.Type,
                                              queue: DispatchQueue? = nil,
                                              completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
    return response(queue: queue,
                    responseSerializer: DataRequest.glossyArrayResponseSerializer(type: T.self),
                    completionHandler: completionHandler)
  }
}

// MARK: – Alamofire.DownloadRequest

public extension DownloadRequest {
  
  // MARK: - Object
  
  public static func glossyObjectResponseSerializer<T: JSONDecodable>(type: T.Type) -> DownloadResponseSerializer<T> {
    return DownloadResponseSerializer { _, response, fileURL, error in
      guard error == nil else { return .failure(error!) }
      
      guard let fileURL = fileURL else {
        return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
      }
      
      do {
        let data = try Data(contentsOf: fileURL)
        return Request.serializeReponseGlossyObject(type: T.self, response: response, data: data, error: error)
      } catch {
        return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
      }
    }
  }
  
  @discardableResult
  public func responseObject<T: JSONDecodable>(_ type: T.Type,
                                               queue: DispatchQueue? = nil,
                                               completionHandler: @escaping (DownloadResponse<T>) -> Void) -> Self {
    return response(queue: queue,
                    responseSerializer: DownloadRequest.glossyObjectResponseSerializer(type: T.self),
                    completionHandler: completionHandler)
  }
  
  // MARK: - Array
  
  public static func glossyArrayResponseSerializer<T: JSONDecodable>(type: T.Type) -> DownloadResponseSerializer<[T]> {
    return DownloadResponseSerializer { _, response, fileURL, error in
      guard error == nil else { return .failure(error!) }
      
      guard let fileURL = fileURL else {
        return .failure(AFError.responseSerializationFailed(reason: .inputFileNil))
      }
      
      do {
        let data = try Data(contentsOf: fileURL)
        return Request.serializeReponseGlossyArray(type: T.self, response: response, data: data, error: error)
      } catch {
        return .failure(AFError.responseSerializationFailed(reason: .inputFileReadFailed(at: fileURL)))
      }
    }
  }
  
  @discardableResult
  public func responseArray<T: JSONDecodable>(_ type: T.Type,
                                              queue: DispatchQueue? = nil,
                                              completionHandler: @escaping (DownloadResponse<[T]>) -> Void) -> Self {
    return response(queue: queue,
                    responseSerializer: DownloadRequest.glossyArrayResponseSerializer(type: T.self),
                    completionHandler: completionHandler)
  }
}

// MARK: - cutie utility function

private func mapJSON(_ data: Data) -> Any {
  do {
    return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
  } catch let error {
    return error
  }
}
