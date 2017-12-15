//
//  LLIndexViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/11/20.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLIndexViewController: LLPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search"),
                                                            target: self,
                                                            action: #selector(selectAction))
    }
    
    @objc private func selectAction() {
        navigationController?.pushViewController(LLSearchViewController(), animated: true)
    }
}


