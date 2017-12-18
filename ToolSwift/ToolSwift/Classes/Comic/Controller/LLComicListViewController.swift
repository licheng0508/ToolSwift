//
//  LLComicListViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/18.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLComicListViewController: LLBaseViewController {
    
    private var argCon: Int = 0
    private var argName: String?
    private var argValue: Int = 0

    convenience init(argCon: Int = 0, argName: String?, argValue: Int = 0) {
        self.init()
        self.argCon = argCon
        self.argName = argName
        self.argValue = argValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
