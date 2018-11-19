//
//  GalleryService.swift
//  simpleGallery
//
//  Created by kirshum on 18/11/2018.
//  Copyright © 2018 kirshum. All rights reserved.
//

import Foundation
import UIKit


class GalleryService {
    
    enum Source: Endpoint {
        case getCards(Int?)
        
        var path: String {
            switch self {
            case let .getCards(startIndex): return   startIndex != nil ? "photos?_start=\(startIndex!)&_limit=10" : "photos?_start=0&_limit=10"
            }
        }
        
        var methood: HTTPMethod { return HTTPMethod.get }
        
        func builder() -> URLRequest {
            return getRequest()
            
        }
        
        private func getRequest() -> URLRequest {
            var req = URLRequest(url: url)
            req.httpMethod = methood.name
            return req
        }
        
    }
    
    var imageCache = NSCache<NSString, UIImage>()
    
    
    
    func loadCards(pageNumber: Int, handler: @escaping (Result<Error, [Card]>) -> Void) {
        let source = Source.getCards(pageNumber)
        let gate = Gateway<Card>()
        gate.load(Resource<[Card]>(request: source.builder())) { (result) in
            switch result {
            case .error(let err): handler(Result.error(err))
            case .success (let parsedData): handler(Result.success(parsedData))
            }
        }
        
    }
    
    func loadImage(urlString: String,handler: @escaping (Result<String, UIImage>) ->Void) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            handler(Result.success(cachedImage))
        } else {
            let gate = Gateway<Card>()
            gate.easyLoad(urlString) { (result) in
                switch result {
                case let .error(err): print(err)
                case let .success(data):
                    guard let img = UIImage(data: data) else { return }
                    self.imageCache.setObject(img, forKey: urlString as NSString)
                    handler(Result.success(img))
                }
            }
        }
    }
    
    
    
    
}

