//
//  LLDetailViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/19.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLDetailViewController: LLBaseViewController {
    
    weak var delegate: LLComicViewWillEndDraggingDelegate?

    var detailStatic: DetailStaticModel?
    var detailRealtime: DetailRealtimeModel?
    var guessLike: GuessLikeModel?
    
    private  lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.delegate = self
        tw.backgroundColor = UIColor.background
        tw.dataSource = self
        tw.separatorStyle = .none
        tw.register(cellType: LLDescriptionTCell.self)
        tw.register(cellType: LLOtherWorksTCell.self)
        tw.register(cellType: LLTicketTCell.self)
        tw.register(cellType: LLGuessLikeTCell.self)
        return tw
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {$0.edges.equalTo(self.view.usnp.edges) }
    }
}

extension LLDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return detailStatic != nil ? 4 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 1 && detailStatic?.otherWorks?.count == 0) ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return LLDescriptionTCell.height(for: detailStatic)
        } else if indexPath.section == 3{
            return 200
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LLDescriptionTCell.self)
            cell.model = detailStatic
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LLOtherWorksTCell.self)
            cell.model = detailStatic
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LLTicketTCell.self)
            cell.model = detailRealtime
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LLGuessLikeTCell.self)
            cell.model = guessLike
            cell.didSelectClosure { [weak self] (comic) in
                let vc = LLComicViewController(comicid: comic.comic_id)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = LLOtherWorksViewController(otherWorks: detailStatic?.otherWorks)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == 1 && detailStatic?.otherWorks?.count == 0) ? CGFloat.leastNormalMagnitude : 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

