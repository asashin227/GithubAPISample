//
//  GitHubAPI.swift
//  GithubAPISample
//
//  Created by Asakura Shinsuke on 2017/07/04.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//

import APIKit

protocol GitHubAPI: Request {
    
}

extension GitHubAPI {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }
}

extension GitHubAPI where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        return try decodeValue(object)
    }
}
