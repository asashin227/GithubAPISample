//
//  RepoListViewController.swift
//  GithubAPISample
//
//  Created by Asakura Shinsuke on 2017/07/08.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepoListViewController: UIViewController {

    fileprivate let viewModel = RepoViewModel()
    let disposeBag = DisposeBag()
    
    
    override func loadView() {
        let reposView = RepoView(frame: UIScreen.main.bounds)
        reposView.table.dataSource = viewModel
        reposView.table.delegate = self
        
        self.view = reposView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func bind() {
        // Connection
        viewModel.repos.asObservable().filter { x in
            return !x.isEmpty
            }.subscribe(onNext: { [unowned self] x in
                (self.view as! RepoView).table.reloadData()
                }, onError: { error in
                    print(error)
            }, onCompleted: { () in
            }, onDisposed: { () in
            }).addDisposableTo(disposeBag)
        
        (view as? RepoView)?.searchBar.rx.text
            .subscribe(onNext: {
                [unowned self] q in
                self.viewModel.reloadData(userName: q!)
                }, onError: { error in
            }, onCompleted: { () in
            }, onDisposed: { () in
            }).addDisposableTo(disposeBag)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RepoListViewController: UITableViewDelegate {
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selected(in: self, indexPath: indexPath)
    }

}
