//
//  LLBookViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/14.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLBookViewController: LLBaseViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.background
        tableView.tableFooterView = UIView()
        tableView.uempty = LLEmptyView { [weak self] in self?.loadData() }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    override func configUI() {
        super.configUI()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalTo(self.view.usnp.edges) }
    }
    
    func loadData() {
        
        tableView.uempty?.allowShow = true
    }
    
}
