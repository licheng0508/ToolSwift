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
        
        //隐藏多余的cell
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.dataArray = ["获取网络接口"];
    }
    
    // MARK: - UITableView 代理/数据源方法
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray?.count ?? 0;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Index_List_Cell)!

        cell.textLabel?.text = self.dataArray?[indexPath.row] ?? "";
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        LLPrint(indexPath.row)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


