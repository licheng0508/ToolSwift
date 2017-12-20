//
//  LLMineHead.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/20.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLMineHead: UIView {

    private lazy var bgView: UIImageView = {
        let bw = UIImageView()
        bw.contentMode = .scaleAspectFill
        return bw
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        addSubview(bgView)
        bgView.snp.makeConstraints {$0.edges.equalToSuperview() }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(sexTypeDidChange), name: .USexTypeDidChange, object: nil)
        sexTypeDidChange()
    }
    
    @objc func sexTypeDidChange() {
        let sexType = UserDefaults.standard.integer(forKey: String.sexTypeKey)
        if sexType == 1 {
            bgView.image = UIImage(named: "mine_bg_for_boy")
        } else {
            bgView.image = UIImage(named: "mine_bg_for_girl")
        }
    }
}

