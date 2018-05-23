//
//  LLCateListViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/14.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLCateListViewController: LLBaseViewController {

    private var searchString = ""
    private var topList = [TopModel]()
    private var rankList = [RankingModel]()
    
    private lazy var searchButon: UIButton = {
        let sn = UIButton(type: .system)
        sn.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 30)
        sn.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        sn.layer.cornerRadius = 15
        sn.setTitleColor(.white, for: .normal)
        sn.setImage(UIImage(named: "nav_search")?.withRenderingMode(.alwaysOriginal), for: .normal)
        sn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        sn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        sn.addTarget(self, action:#selector(searchAction), for: .touchUpInside)
        return sn
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.minimumInteritemSpacing = 10
        lt.minimumLineSpacing = 10
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor.white
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceVertical = true
        cw.register(cellType: LLRankCCell.self)
        cw.register(cellType: LLTopCCell.self)
        cw.MJHead = LLRefreshHeader { [weak self] in self?.loadData() }
        cw.uempty = LLEmptyView { [weak self] in self?.loadData() }
        return cw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(true)
    }
    
    private func loadData(_ showloading: Bool = false) {
        
        ApiToolProvider(showloading).request(ApiTool.cateList, model: CateListModel.self) { (returnData) in
            self.collectionView.uempty?.allowShow = true
            
            self.searchString = returnData?.recommendSearch ?? ""
            self.topList = returnData?.topList ?? []
            self.rankList = returnData?.rankingList ?? []
            
            self.searchButon.setTitle(self.searchString, for: .normal)
            self.collectionView.reloadData()
            self.collectionView.MJHead.endRefreshing()
        }
    }
    
    @objc private func searchAction() {
        navigationController?.pushViewController(LLSearchViewController(), animated: true)
    }
    
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.titleView = searchButon
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil,
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            style: .plain,
                                                            target: nil,
                                                            action: nil)
    }
    
}

extension LLCateListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return topList.takeMax(3).count
        } else {
            return rankList.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LLTopCCell.self)
            cell.model = topList[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LLRankCCell.self)
            cell.model = rankList[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, section == 0 ? 0 : 10, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(screenWidth - 40.0) / 3.0)
        return CGSize(width: width, height: (indexPath.section == 0 ? 55 : (width * 0.75 + 30)))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let model = topList[indexPath.row]
            var titles: [String] = []
            var vcs: [UIViewController] = []
            for tab in model.extra?.tabList ?? [] {
                guard let tabTitle = tab.tabTitle else { continue }
                titles.append(tabTitle)
                vcs.append(LLComicListViewController(argCon: tab.argCon,
                                                    argName: tab.argName,
                                                    argValue: tab.argValue))
            }
            let vc = LLPageViewController(titles: titles, vcs: vcs, pageStyle: .topTabBar)
            vc.title = model.sortName
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.section == 1 {
            let model = rankList[indexPath.row]
            let vc = LLComicListViewController(argCon: model.argCon,
                                              argName: model.argName,
                                              argValue: model.argValue)
            vc.title = model.sortName
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

