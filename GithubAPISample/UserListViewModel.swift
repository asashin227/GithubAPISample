//
//  UserListViewModel.swift
//  GithubAPISample
//
//  Created by Asakura Shinsuke on 2017/07/04.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//

import UIKit
import RxSwift
import APIKit

class UserListViewModel: NSObject {
    let cellId = "CellId"
    private(set) var users = [User]
    
    let disposeBag = DisposeBag()
    
    func reloadData(category: GetRecipe.CategoryType, compleated: (()->Void)? = nil) {
        let request = GetRecipe(categoryType: category)
        Session.rx_sendRequest(request: request)
            .subscribe {
                [weak self] event in
                switch event {
                case .next(let result):
                    self?.recipes.value = result
                    
                case .error(let error):
                    self?.error.value = error
                case .completed:
                    compleated?()
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    func selctRecipes(keyword: String) {
        visibleRecipes = recipes.value.filter() {
            $0.categoryName.hasPrefix(keyword)
        }
    }
    
    func selected(in viewController: UIViewController, indexPath: IndexPath) {
        let model = visibleRecipes[indexPath.row]
        OpenWebContents(viewController, urlString: model.categoryUrl)
    }
    
    func selected(in viewController: UIViewController, recipe: Recipe) {
        OpenWebContents(viewController, urlString: recipe.categoryUrl)
    }
    
    func chooseRecipe() -> Recipe {
        return visibleRecipes[Int(arc4random_uniform(UInt32(visibleRecipes.count - 1)))]
    }
    
    func showAlert(recipe: Recipe, handler: @escaping (Recipe) -> Void) {
        UIAlertController.create(title: "今日のご飯はこれ！", message: recipe.categoryName)
            .add(title: "レシピを見る") {
                _ in
                handler(recipe)
            }.add(title: "もう一度探す") {
                _ in
                self.showAlert(recipe: self.chooseRecipe(), handler: handler)
            }
            .addCancel().show()
    }
    
    // MARK: - DataSourceメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId);
        let model = visibleRecipes[indexPath.row]
        
        cell.textLabel?.text = model.categoryName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleRecipes.count
    }
}
