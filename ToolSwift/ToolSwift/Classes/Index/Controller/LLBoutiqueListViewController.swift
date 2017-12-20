//
//  LLBoutiqueListViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/14.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit
import LLCycleScrollView

class LLBoutiqueListViewController: LLBaseViewController {

    private var sexType: Int = UserDefaults.standard.integer(forKey: String.sexTypeKey)
    private var galleryItems = [GalleryItemModel]()
    private var TextItems = [TextItemModel]()
    private var comicLists = [ComicListModel]()
    
    private lazy var bannerView: LLCycleScrollView = {
        let bw = LLCycleScrollView()
        bw.backgroundColor = UIColor.background
        bw.autoScrollTimeInterval = 5
        bw.placeHolderImage = UIImage(named: "normal_placeholder")
        bw.coverImage = UIImage()
        bw.pageControlPosition = .center
        bw.pageControlBottom = 20
        bw.titleBackgroundColor = UIColor.clear
        bw.lldidSelectItemAtIndex = didSelectBanner(index:)
        return bw
    }()
    
    private lazy var sexTypeButton: UIButton = {
        let sn = UIButton(type: .custom)
        sn.setTitleColor(UIColor.black, for: .normal)
        sn.addTarget(self, action: #selector(changeSex), for: .touchUpInside)
        return sn
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = LLCollectionViewSectionBackgroundLayout()
        lt.minimumInteritemSpacing = 5
        lt.minimumLineSpacing = 10
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor.background
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceVertical = true
        cw.contentInset = UIEdgeInsetsMake(screenWidth * 0.467, 0, 0, 0)
        cw.scrollIndicatorInsets = cw.contentInset
        cw.register(cellType: LLComicCCell.self)
        cw.register(cellType: LLBoardCCell.self)
        cw.register(supplementaryViewType: LLComicCHeadView.self, ofKind: UICollectionElementKindSectionHeader)
        cw.register(supplementaryViewType: LLComicCFootView.self, ofKind: UICollectionElementKindSectionFooter)
        cw.MJHead = LLRefreshHeader { [weak self] in self?.loadData(showloading: false) }
        cw.MJFoot = LLRefreshDiscoverFooter()
        cw.uempty = LLEmptyView(verticalOffset: -(cw.contentInset.top)) { [weak self] in self?.loadData(showloading: true) }
        return cw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData(showloading: true)
    }
    
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(collectionView.contentInset.top)
        }
        
        view.addSubview(sexTypeButton)
        sexTypeButton.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.bottom.equalToSuperview().offset(-20)
            $0.right.equalToSuperview()
        }
    }
    
    private func loadData(_ changeSex: Bool = false, showloading: Bool){
    
        if changeSex {
            sexType = 3 - sexType
            UserDefaults.standard.set(sexType, forKey: String.sexTypeKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: .USexTypeDidChange, object: nil)
        }
        
        ApiToolProvider(showloading).request(ApiTool.boutiqueList(sexType: sexType), model: BoutiqueListModel.self) { [weak self] (returnData) in
            
            self?.galleryItems = returnData?.galleryItems ?? []
            self?.TextItems = returnData?.textItems ?? []
            self?.comicLists = returnData?.comicLists ?? []
            
            self?.sexTypeButton.setImage(UIImage(named: self?.sexType == 1 ? "gender_male" : "gender_female"),
                                         for: .normal)
            
            self?.collectionView.MJHead.endRefreshing()
            self?.collectionView.uempty?.allowShow = true
            
            self?.collectionView.reloadData()
            self?.bannerView.imagePaths = self?.galleryItems.map { $0.cover! } ?? []
        }
    }
    
    private func didSelectBanner(index: NSInteger) {
        let item = galleryItems[index]
        if item.linkType == 2 {
            guard let url = item.ext?.flatMap({ return $0.key == "url" ? $0.val : nil }).joined() else { return }
            let vc = LLWebViewController(url: url)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let comicIdString = item.ext?.flatMap({ return $0.key == "comicId" ? $0.val : nil }).joined(),
                let comicId = Int(comicIdString) else { return }
            let vc = LLComicViewController(comicid: comicId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func changeSex() {
        loadData(true, showloading: true)
    }
}

extension LLBoutiqueListViewController: LLCollectionViewSectionBackgroundLayoutDelegateLayout, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comicLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = comicLists[section]
        return comicList.comics?.takeMax(4).count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, for: indexPath, viewType: LLComicCHeadView.self)
            let comicList = comicLists[indexPath.section]
            head.iconView.kf.setImage(urlString: comicList.newTitleIconUrl)
            head.titleLabel.text = comicList.itemTitle
            head.moreActionClosure { [weak self] in
                if comicList.comicType == .thematic {
                    let vc = LLPageViewController(titles: ["漫画",
                                                          "次元"],
                                                 vcs: [LLSpecialViewController(argCon: 2),
                                                       LLSpecialViewController(argCon: 4)],
                                                 pageStyle: .navgationBarSegment)
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else if comicList.comicType == .animation {
                    let vc = LLWebViewController(url: "http://m.u17.com/wap/cartoon/list")
                    vc.title = "动画"
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else if comicList.comicType == .update {
                    let vc = LLUpdateListViewController(argCon: comicList.argCon,
                                                       argName: comicList.argName,
                                                       argValue: comicList.argValue)
                    vc.title = comicList.itemTitle
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = LLComicListViewController(argCon: comicList.argCon,
                                                      argName: comicList.argName,
                                                      argValue: comicList.argValue)
                    vc.title = comicList.itemTitle
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return head
        } else {
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, for: indexPath, viewType: LLComicCFootView.self)
            return foot
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = comicLists[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return comicLists.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LLBoardCCell.self)
            cell.model = comicList.comics?[indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LLComicCCell.self)
            if comicList.comicType == .thematic {
                cell.style = .none
            } else {
                cell.style = .withTitieAndDesc
            }
            cell.model = comicList.comics?[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let width = floor((screenWidth - 15.0) / 4.0)
            return CGSize(width: width, height: 80)
        }else {
            if comicList.comicType == .thematic {
                let width = floor((screenWidth - 5.0) / 2.0)
                return CGSize(width: width, height: 120)
            } else {
                let count = comicList.comics?.takeMax(4).count ?? 0
                let warp = count % 2 + 2
                let width = floor((screenWidth - CGFloat(warp - 1) * 5.0) / CGFloat(warp))
                return CGSize(width: width, height: CGFloat(warp * 80))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = comicLists[indexPath.section]
        guard let item = comicList.comics?[indexPath.row] else { return }
        
        if comicList.comicType == .billboard {
            let vc = LLComicListViewController(argName: item.argName,
                                              argValue: item.argValue)
            vc.title = item.name
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if item.linkType == 2 {
                guard let url = item.ext?.flatMap({ return $0.key == "url" ? $0.val : nil }).joined() else { return }
                let vc = LLWebViewController(url: url)
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = LLComicViewController(comicid: item.comicId)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            bannerView.snp.updateConstraints{ $0.top.equalToSuperview().offset(min(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))) }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            UIView.animate(withDuration: 0.5, animations: {
                self.sexTypeButton.transform = CGAffineTransform(translationX: 50, y: 0)
            })
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            UIView.animate(withDuration: 0.5, animations: {
                self.sexTypeButton.transform = CGAffineTransform.identity
            })
        }
    }
}

