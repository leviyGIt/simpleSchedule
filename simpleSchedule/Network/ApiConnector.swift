//
//  ApiConnector.swift
//  simpleGallery
//
//  Created by kirshum on 18/11/2018.
//  Copyright © 2018 kirshum. All rights reserved.
//

import Foundation

class APIConnector {
    var session = URLSession.shared
    static let shared: APIConnector = APIConnector()
    typealias Response = Result<Error, Data>
    
    func load<T>(request: Resource<T>, callback: @escaping (Result<Error, Data>) -> Void) {
        let task = session.dataTask(with: request.request) { (data, response, err) in
            if err != nil {
                callback(Result.error(err!))
            } else {
                DispatchQueue.main.async {
                    guard let json = data else { callback(Result.error(URLErrors.emptyResponse)); return }
                    if (response as! HTTPURLResponse).statusCode > 300 {
                        
                        guard (try? JSONDecoder().decode(ServerError.self, from: json)) != nil else {
                            
                            callback(Result.error(URLErrors.parseError));
                            return
                        }
                        callback(Result.error(URLErrors.errorError))
                    } else {
                        callback(Result.success(json))
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    
    
    func simpleLoad(_ url: URL, callback: @escaping (Result<Error, Data>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                callback(Result.success(data))
            }
        }
        task.resume()
        
        
    }
    
    
    
    
    
    
    
    
    
}


