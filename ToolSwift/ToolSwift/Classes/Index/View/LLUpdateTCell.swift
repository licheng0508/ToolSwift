//
//  LLUpdateTCell.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/20.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLUpdateTCell: LLBaseTableViewCell {

    private lazy var coverView: UIImageView = {
        let cw = UIImageView()
        cw.contentMode = .scaleAspectFill
        cw.layer.cornerRadius = 5
        cw.layer.masksToBounds = true
        return cw
    }()
    
    private lazy var tipLabel: UILabel = {
        let tl = UILabel()
        tl.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        tl.textColor = UIColor.white
        tl.font = UIFont.systemFont(ofSize: 9)
        return tl
    }()
    
    override func configUI() {
        
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 20, 10))
        }
        
        coverView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        let line = UIView().then{
            $0.backgroundColor = UIColor.background
        }
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(10)
        }
    }
    
    var model: ComicModel? {
        didSet {
            guard let model = model else { return }
            coverView.kf.setImage(urlString: model.cover)
            tipLabel.text = "    \(model.description ?? "")"
        }
    }
}

