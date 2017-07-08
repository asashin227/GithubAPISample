//
//  RepositoryRequest.swift
//  GithubAPISample
//
//  Created by Asakura Shinsuke on 2017/07/04.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//

import APIKit
import Himotoki

struct RepositoryRequest: GitHubAPI {
    var userName: String
    var path: String {
        return "/users/\(self.userName)/repos"
    }
    typealias Response = [Repository]
    
    var method: HTTPMethod {
        return .get
    }
    
    init(userName: String) {
        self.userName = userName
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> RepositoryRequest.Response {
        return try decodeArray(object)
    }
}
