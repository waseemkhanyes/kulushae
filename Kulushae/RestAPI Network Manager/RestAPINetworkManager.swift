//
//  RestAPINetworkManager.swift
//  Kulushae
//
//  Created by ios on 11/12/2023.
//

import Foundation
import Alamofire

class RestAPINetworkManager {
    static let shared = RestAPINetworkManager()
    
    private init() {}
    private func addAppLanguageHeader(_ headers: inout HTTPHeaders) {
        headers["X-App-Language"] = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
    }
    
    func request(_ url: URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 headers: HTTPHeaders? = nil,
                 completion: @escaping (AFResult<Data>) -> Void) {
        var updatedHeaders = headers ?? HTTPHeaders()
        addAppLanguageHeader(&updatedHeaders)
        
        AF.request(url,
                   method: method,
                   parameters: parameters,
                   encoding: encoding,
                   headers: updatedHeaders)
        .validate(statusCode: 200..<300)
        .responseData { response in
            completion(response.result)
        }
    }
    
    // Additional method for POST requests
    func postRequest(url: URLConvertible,
                     parameters: Parameters? = nil,
                     encoding: ParameterEncoding = JSONEncoding.default,
                     headers: HTTPHeaders? = nil,
                     completion: @escaping (AFResult<Data>) -> Void) {
        var updatedHeaders = headers ?? HTTPHeaders()
        addAppLanguageHeader(&updatedHeaders)
        
        AF.request(url, method: .post, parameters: parameters, encoding: encoding, headers: updatedHeaders)
            .validate(statusCode: 200..<300)
            .responseData { response in
                completion(response.result)
            }
    }
    
    // Additional method for PUT requests
    func put(_ url: URLConvertible,
             parameters: Parameters? = nil,
             encoding: ParameterEncoding = JSONEncoding.default,
             headers: HTTPHeaders? = nil,
             completion: @escaping (AFResult<Data>) -> Void) {
        var updatedHeaders = headers ?? HTTPHeaders()
        addAppLanguageHeader(&updatedHeaders)
        request(url, method: .put, parameters: parameters, encoding: encoding, headers: updatedHeaders, completion: completion)
    }
    
    // Additional method for DELETE requests
    func delete(_ url: URLConvertible,
                parameters: Parameters? = nil,
                encoding: ParameterEncoding = URLEncoding.default,
                headers: HTTPHeaders? = nil,
                completion: @escaping (AFResult<Data>) -> Void) {
        var updatedHeaders = headers ?? HTTPHeaders()
        addAppLanguageHeader(&updatedHeaders)
        request(url, method: .delete, parameters: parameters, encoding: encoding, headers: updatedHeaders, completion: completion)
    }
    
    // Additional method for GET requests
    func getRequest(url: URLConvertible,
                    parameters: Parameters? = nil,
                    headers: HTTPHeaders? = nil,
                    completion: @escaping (AFResult<Data>) -> Void) {
        var updatedHeaders = headers ?? HTTPHeaders()
        addAppLanguageHeader(&updatedHeaders)
        AF.request(url, method: .get, parameters: parameters,headers: updatedHeaders).validate().responseData { response in
            completion(response.result)
        }
    }
    
    func callEndPoint(url: URLConvertible,
                      method: HTTPMethod = .post,
                    parameters: Parameters? = nil,
                    encoding: ParameterEncoding = URLEncoding.default,
                    headers: HTTPHeaders? = nil,
                      completion: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate() // Optionally validate the response
            .responseJSON { response in
                completion(response)
            }
    }
}
