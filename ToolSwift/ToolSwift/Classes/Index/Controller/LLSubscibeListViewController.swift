//
//  LLSubscibeListViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/14.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLSubscibeListViewController: LLBaseViewController {

    private var subscribeList = [ComicListModel]()
    
    private lazy var collectionView: UICollectionView = {
        let lt = LLCollectionViewSectionBackgroundLayout()
        lt.minimumInteritemSpacing = 5
        lt.minimumLineSpacing = 10
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor.background
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceVertical = true
        cw.register(cellType: LLComicCCell.self)
        cw.register(supplementaryViewType: LLComicCHeadView.self, ofKind: UICollectionElementKindSectionHeader)
        cw.register(supplementaryViewType: LLComicCFootView.self, ofKind: UICollectionElementKindSectionFooter)
        cw.MJHead = LLRefreshHeader{ [weak self] in self?.loadData() }
        cw.MJFoot = LLRefreshTipKissFooter(with: "使用妖气币可以购买订阅漫画\nVIP会员购买还有优惠哦~")
        cw.uempty = LLEmptyView { [weak self] in self?.loadData() }
        return cw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData(true)
    }
    
    private func loadData(_ showloading: Bool = false) {
        
        ApiToolProvider(showloading).request(ApiTool.subscribeList, model: SubscribeListModel.self) { (returnData) in
            self.collectionView.MJHead.endRefreshing()
            self.collectionView.uempty?.allowShow = true
            
            self.subscribeList = returnData?.newSubscribeList ?? []
            self.collectionView.reloadData()
        }
    }
    
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }
}

extension LLSubscibeListViewController: LLCollectionViewSectionBackgroundLayoutDelegateLayout, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return subscribeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = subscribeList[section]
        return comicList.comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, for: indexPath, viewType: LLComicCHeadView.self)
            let comicList = subscribeList[indexPath.section]
            head.iconView.kf.setImage(urlString: comicList.titleIconUrl)
            head.titleLabel.text = comicList.itemTitle
            head.moreButton.isHidden = !comicList.canMore
            head.moreActionClosure { [weak self] in
                let vc = LLComicListViewController(argCon: comicList.argCon, argName: comicList.argName, argValue: comicList.argValue)
                vc.title = comicList.itemTitle
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return head
        } else {
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, for: indexPath, viewType: LLComicCFootView.self)
            return foot
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = subscribeList[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return subscribeList.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LLComicCCell.self)
        cell.style = .withTitle
        let comicList = subscribeList[indexPath.section]
        cell.model = comicList.comics?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(screenWidth - 10.0) / 3.0)
        return CGSize(width: width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = subscribeList[indexPath.section]
        guard let model = comicList.comics?[indexPath.row] else { return }
        let vc = LLComicViewController(comicid: model.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
}

