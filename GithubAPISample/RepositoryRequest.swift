//
//  RepositoryRequest.swift
//  GithubAPISample
//
//  Created by Asakura Shinsuke on 2017/07/04.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//

import UIKit

struct RepositoryRequest: GitHubAPI {
    var userName: String
    var repository: String
    var path: String {
        return "/users/\(self.userName)/\(self.repository)"
    }
    typealias Response = [User]
    
    var method: HTTPMethod {
        return .get
    }
    
    init(userName: String, repository: String) {
        self.userName = userName
        self.repository = repository
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> FetchRepositoryRequest.Response {
        return try decodeArray(object)
    }
}
