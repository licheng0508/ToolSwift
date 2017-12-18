//
//  LLSpecialViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/18.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLSpecialViewController: LLBaseViewController {

    private var argCon: Int = 0
    
    convenience init(argCon: Int = 0) {
        self.init()
        self.argCon = argCon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
