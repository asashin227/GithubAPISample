//
//  UserRequest.swift
//  GithubAPISample
//
//  Created by Asakura Shinsuke on 2017/07/04.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//


struct UserRequest: GitHubAPI {
    var userName: String
    var path: String {
        return "/users/\(self.userName)"
    }
    typealias Response = [User]
    
    var method: HTTPMethod {
        return .get
    }
    
    init(userName: String) {
        self.userName = userName
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> FetchRepositoryRequest.Response {
        return try decodeArray(object)
    }
}
