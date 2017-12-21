//
//  LLMineViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/14.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLMineViewController: LLBaseViewController {

    private lazy var myArray: [[[String: String]]] = {
        if let path = Bundle.main.path(forResource: "mineListData", ofType: "plist") {
            if let array = NSArray(contentsOfFile: path) as? [[[String: String]]] {
                return array
            }
            return [[[:]]]
        }
        return [[[:]]]
    }()
    
    private lazy var dataArray: [[MineListDataModel]] = {
        var dataA: [[MineListDataModel]] = [[]]
        for tempArray in myArray {
            var listArray: [MineListDataModel] = []
            for dic in tempArray{
                if let model = MineListDataModel.deserialize(from: dic) {
                    listArray.append(model)
                }
            }
            dataA.append(listArray)
        }
        return dataA
    }()
    
    private lazy var head: LLMineHead = {
        return LLMineHead(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
    }()
    
    private lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    
    lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .grouped)
        tw.backgroundColor = UIColor.background
        tw.delegate = self
        tw.dataSource = self
        tw.rowHeight = 50
        tw.register(cellType: LLBaseTableViewCell.self)
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .top
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges).priority(.low)
            $0.top.equalToSuperview()
        }
        
        tableView.parallaxHeader.view = head
        tableView.parallaxHeader.height = 200
        tableView.parallaxHeader.minimumHeight = navigationBarY
        tableView.parallaxHeader.mode = .fill
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.clear)
        tableView.contentOffset = CGPoint(x: 0, y: -tableView.parallaxHeader.height)
    }
}

extension LLMineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -(scrollView.parallaxHeader.minimumHeight) {
            navigationController?.barStyle(.theme)
            navigationItem.title = "我的"
        } else {
            navigationController?.barStyle(.clear)
            navigationItem.title = ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArray = dataArray[section]
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LLBaseTableViewCell.self)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .default
        let sectionArray = dataArray[indexPath.section]
        let model = sectionArray[indexPath.row]
        cell.imageView?.image =  UIImage(named: model.icon ?? "")
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

