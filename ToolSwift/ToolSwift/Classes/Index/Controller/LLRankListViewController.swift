//
//  LLRankListViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/14.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLRankListViewController: LLBaseViewController {

    private var rankList = [RankingModel]()
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.backgroundColor = UIColor.background
        tw.tableFooterView = UIView()
        tw.separatorStyle = .none
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: LLRankTCell.self)
        tw.MJHead = LLRefreshHeader{ [weak self] in self?.loadData() }
        tw.uempty = LLEmptyView { [weak self] in self?.loadData() }
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData(true)
    }
    
    @objc private func loadData(_ showloading: Bool = false) {
        
        ApiToolProvider(showloading).request(ApiTool.rankList, model: RankinglistModel.self) { (returnData) in
            self.tableView.MJHead.endRefreshing()
            self.tableView.uempty?.allowShow = true
            
            self.rankList = returnData?.rankinglist ?? []
            self.tableView.reloadData()
        }
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }
}

extension LLRankListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LLRankTCell.self)
        cell.model = rankList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenWidth * 0.4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = rankList[indexPath.row]
        let vc = LLComicListViewController(argCon: model.argCon,
                                          argName: model.argName,
                                          argValue: model.argValue)
        vc.title = "\(model.title!)榜"
        navigationController?.pushViewController(vc, animated: true)
    }
}

