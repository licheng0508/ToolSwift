//
//  LLComicListViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/18.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLComicListViewController: LLBaseViewController {
    
    private var argCon: Int = 0
    private var argName: String?
    private var argValue: Int = 0
    private var page: Int = 1
    
    private var comicList = [ComicModel]()
    private var spinnerName: String?
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.backgroundColor = UIColor.background
        tw.tableFooterView = UIView()
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: LLComicTCell.self)
        tw.MJHead = LLRefreshHeader { [weak self] in self?.loadData(more: false) }
        tw.MJFoot = LLRefreshFooter { [weak self] in self?.loadData(more: true) }
        tw.uempty = LLEmptyView { [weak self] in self?.loadData(more: false) }
        return tw
    }()
    
    convenience init(argCon: Int = 0, argName: String?, argValue: Int = 0) {
        self.init()
        self.argCon = argCon
        self.argName = argName
        self.argValue = argValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData(true, more: false)
    }
    
    @objc private func loadData(_ showloading: Bool = false, more: Bool) {
        page = (more ? ( page + 1) : 1)
        
        ApiToolProvider(showloading).request(ApiTool.comicList(argCon: argCon, argName: argName ?? "", argValue: argValue, page: page),
                                   model: ComicListModel.self) { [weak self] (returnData) in
                                    self?.tableView.MJHead.endRefreshing()
                                    if returnData?.hasMore == false {
                                        self?.tableView.MJFoot.endRefreshingWithNoMoreData()
                                    } else {
                                        self?.tableView.MJFoot.endRefreshing()
                                    }
                                    self?.tableView.uempty?.allowShow = true
                                    
                                    if !more { self?.comicList.removeAll() }
                                    self?.comicList.append(contentsOf: returnData?.comics ?? [])
                                    self?.tableView.reloadData()
                                    
                                    guard let defaultParameters = returnData?.defaultParameters else { return }
                                    self?.argCon = defaultParameters.defaultArgCon
                                    self?.spinnerName = defaultParameters.defaultConTagType
        }
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }
}

extension LLComicListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LLComicTCell.self)
        cell.spinnerName = spinnerName
        cell.indexPath = indexPath
        cell.model = comicList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = comicList[indexPath.row]
        let vc = LLComicViewController(comicid: model.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
}


