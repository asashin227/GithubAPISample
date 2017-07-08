//
//  Repository.swift
//  GithubAPISample
//
//  Created by Asakura Shinsuke on 2017/07/04.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//

import Himotoki

struct Repository: Decodable {
    let fullName: String
    let ownerAvatarUrl: String
    let language: String?
    let url: String
    let htmlUrl: String
    
    static func decode(_ e: Extractor) throws -> Repository {
        return try Repository(
            fullName: e <| "full_name",
            ownerAvatarUrl: e <| ["owner", "avatar_url"],
            language: e <|? "language",
            url: e <| "url",
            htmlUrl: e <| "html_url"
        )
    }
}
