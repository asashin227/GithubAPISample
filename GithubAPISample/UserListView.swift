//
//  UserListView.swift
//  GithubAPISample
//
//  Created by Asakura Shinsuke on 2017/07/04.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//

import UIKit

class UserListView: UIView {

    lazy var table: UITableView = self.createTableView()
    lazy var searchBar: UISearchBar = self.createSearchBar()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame);
        table.addSubview(searchBar)
        self.addSubview(table);
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        table.frame = self.frame
        searchBar.frame.size.width = self.frame.size.width
        searchBar.frame.size.height = 40
    }
    
    func createTableView() -> UITableView {
        let tView = UITableView(frame: .zero, style: .grouped);
        tView.backgroundColor = .lightGray
        return tView
    }
    
    func createSearchBar() -> UISearchBar {
        let sBar = UISearchBar(frame: .zero)
        return sBar
    }
}
