//
//  SessionExt.swift
//  GithubAPISample
//
//  Created by Asakura Shinsuke on 2017/07/04.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//

import APIKit
import RxSwift

extension Session {
    func rx_sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return Observable.create { observer in
            let task = self.send(request) { result in
                switch result {
                case .success(let res):
                    observer.on(.next(res))
                    observer.on(.completed)
                case .failure(let err):
                    Log(err.localizedDescription)
                    observer.onError(err)
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
    class func rx_sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return shared.rx_sendRequest(request: request)
    }
}
