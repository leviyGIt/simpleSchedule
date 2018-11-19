//
//  EndPoints.swift
//  simpleGallery
//
//  Created by kirshum on 18/11/2018.
//  Copyright © 2018 kirshum. All rights reserved.
//

import Foundation

public protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var methood: HTTPMethod { get }
    var url: URL { get }
    
    func builder() -> URLRequest
}

extension Endpoint {
    var baseUrl: String { return "https://jsonplaceholder.typicode.com/" }
    
    var url: URL {
        let urlstr = baseUrl + path
        let x = urlstr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return URL(string: x!)!
        
    }
    
}

public enum HTTPMethod {
    case get
    case post
    case getAuth
    case postAuth
    
    var name: String {
        switch self {
        case .get, .getAuth: return "GET"
        case .post, .postAuth: return "POST"
        }
    }
}

public enum Result<E, T> {
    case error(E)
    case success(T)
}

public struct Resource<T> {
    let request: URLRequest
    let handler: (Data) -> T?
}

extension Resource where T: Decodable {
    init(request: URLRequest) {
        self.request = request
        let decoder = JSONDecoder()
        self.handler = {
            try? decoder.decode(T.self, from: $0)
        }
    }
}

public enum URLErrors: Error {
    case emptyResponse
    case parseError
    case errorError
    
    var localizedDescription: String {
        switch self {
        case .emptyResponse: return "Сервер не предоставил данные"
        case .parseError: return "Ошбика обработки данных с сервера"
        case .errorError: return "Неопределнная ошибка со стороны сервер"
        }
    }
}

struct ServerError: Decodable {
    let error: String
}

