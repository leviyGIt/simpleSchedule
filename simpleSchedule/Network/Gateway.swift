//
//  Gateway.swift
//  simpleGallery
//
//  Created by kirshum on 18/11/2018.
//  Copyright © 2018 kirshum. All rights reserved.
//

import Foundation

class Gateway<T: Decodable> {
    
    func load(_ resource: Resource<[T]>, callback: @escaping (Result<Error, [T]>) -> ()) {
        APIConnector.shared.load(request: resource) { (result) in
            switch result {
            case .error(let err): callback(Result.error(err))
            case .success(let json):
                
                if let response = resource.handler(json) {
                    
                    callback(Result.success(response))
                    
                } else {
                   
                    callback(Result.error(URLErrors.parseError))
                }
            }
        }
    }
    
    
    
    func easyLoad(_ url: String,callback: @escaping (Result<Error, Data>) -> ()) {
        guard let url = URL(string: url) else {return }
        APIConnector.shared.simpleLoad(url) { (result) in
            switch result {
            case .error(let err): callback(Result.error(err))
            case .success(let data): callback(Result.success(data))
                
            }
            
        }
    }
}

