//
//  LLReadTopBar.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/19.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLReadTopBar: UIView {

    lazy var backButton: UIButton = {
        let bn = UIButton(type: .custom)
        bn.setImage(UIImage(named: "nav_back_black"), for: .normal)
        return bn
    }()
    
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.textColor = UIColor.black
        tl.font = UIFont.boldSystemFont(ofSize: 18)
        return tl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
        addSubview(backButton)
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.left.centerY.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 50, 0, 50))
        }
    }
}

