//
//  LLIndexViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/11/20.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLIndexViewController: UITableViewController {

    // MARK: - 变量
    
    /// cellID
    let Index_List_Cell = "LLIndexListCell"
    
    /// 数据源
    var dataArray: [String]?{
        
        didSet{
            //刷新数据
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataArray = ["1", "2"];
    }
    
    // MARK: - UITableView 代理/数据源方法
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray?.count ?? 0;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: Index_List_Cell)
        
        cell.textLabel?.text = self.dataArray?[indexPath.row] ?? "";
        
        return cell;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


