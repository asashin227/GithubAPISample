//
//  ViewController.swift
//  GithubAPISample
//
//  Created by Asakura Shinsuke on 2017/07/04.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//

import UIKit
import APIKit
import RxSwift
import RxCocoa

private extension Selector {
    static let didTapedSugestButton = #selector(HomeViewController.didTapedSugestButton(sender:))
}

class UserListViewController: UIViewController, UITableViewDelegate {
    private let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let homeView = HomeView(frame: ScreenRect)
        homeView.table.dataSource = viewModel
        homeView.table.delegate = self
        
        self.view = homeView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        sugestRecipe()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "決めてもらう", style: .plain, target: self, action: .didTapedSugestButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func bind() {
        // Connection
        viewModel.recipes.asObservable().filter { x in
            return !x.isEmpty
            }.subscribe(onNext: { [unowned self] x in
                self.viewModel.visibleRecipes = x
                (self.view as! HomeView).table.reloadData()
                }, onError: { error in
            }, onCompleted: { () in
            }, onDisposed: { () in
            }).addDisposableTo(disposeBag)
        
        (view as? HomeView)?.searchBar.rx.text
            .subscribe(onNext: { [unowned self] q in
                self.viewModel.selctRecipes(keyword: q!)
                (self.view as! HomeView).table.reloadData()
                }, onError: { error in
            }, onCompleted: { () in
            }, onDisposed: { () in
            }).addDisposableTo(disposeBag)
        
    }
    
    private func sugestRecipe() {
        self.viewModel.reloadData(category: .small) {
            self.viewModel.showAlert(recipe: self.viewModel.chooseRecipe()) {
                recipe in
                self.viewModel.selected(in: self, recipe: recipe)
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Event
    func didTapedSugestButton(sender: UIBarButtonItem) {
        sugestRecipe()
    }
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selected(in: self, indexPath: indexPath)
}
