//
//  RepoViewModel.swift
//  GithubAPISample
//
//  Created by Asakura Shinsuke on 2017/07/08.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import APIKit
import SafariServices

class RepoViewModel: NSObject {
    let cellId = "Cell"
    fileprivate(set) var repos = Variable<[Repository]>([])
    let disposeBag = DisposeBag()
    
    func reloadData(userName: String, compleated: (()->Void)? = nil) {
        let request = RepositoryRequest(userName: userName)
        Session.rx_sendRequest(request: request)
            .subscribe {
                [weak self] event in
                switch event {
                case .next(let result):
                    self?.repos.value = result
                case .error(let error):
                    print(error)
                    
                case .completed:
                    compleated?()
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    func selected(in viewController: UIViewController, indexPath: IndexPath) {
        let model = repos.value[indexPath.row]
        let safariViewController = SFSafariViewController(url: NSURL(string: model.htmlUrl)! as URL)
        viewController.present(safariViewController, animated: true, completion: nil);
    }
}


extension RepoViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let model = repos.value[indexPath.row]
        
        cell.textLabel?.text = model.fullName
        cell.detailTextLabel?.text = model.language
        return cell
    }
}
