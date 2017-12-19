//
//  LLCommentViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/19.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLCommentViewController: LLBaseViewController {

    weak var delegate: LLComicViewWillEndDraggingDelegate?
    
    var detailStatic: DetailStaticModel?
    var commentList: CommentListModel? {
        didSet {
            guard let commentList = commentList?.commentList else { return }
            let viewModelArray = commentList.flatMap { (comment) -> LLCommentViewModel? in
                return LLCommentViewModel(model: comment)
            }
            listArray.append(contentsOf: viewModelArray)
        }
    }
    
    private var listArray = [LLCommentViewModel]()
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: LLCommentTCell.self)
        tw.MJFoot = LLRefreshFooter { self.loadData() }
        return tw
        
    }()
    
    func loadData() {
        ApiToolProvider().request(ApiTool.commentList(object_id: detailStatic?.comic?.comic_id ?? 0,
                                             thread_id: detailStatic?.comic?.thread_id ?? 0,
                                             page: commentList?.serverNextPage ?? 0),
                            model: CommentListModel.self) { (returnData) in
                                if returnData?.hasMore == true {
                                    self.tableView.MJFoot.endRefreshing()
                                } else {
                                    self.tableView.MJFoot.endRefreshingWithNoMoreData()
                                }
                                self.commentList = returnData
                                self.tableView.reloadData()
        }
    }
    
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

extension LLCommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listArray[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LLCommentTCell.self)
        cell.viewModel = listArray[indexPath.row]
        return cell
    }
}


