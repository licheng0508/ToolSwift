//
//  LLComicViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/18.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLComicViewController: LLBaseViewController {
    
    private var comicid: Int = 0
    
    convenience init(comicid: Int) {
        self.init()
        self.comicid = comicid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        edgesForExtendedLayout = .top
    }
}
