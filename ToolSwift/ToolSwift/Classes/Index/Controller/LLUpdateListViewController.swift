//
//  LLUpdateListViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/18.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLUpdateListViewController: LLBaseViewController {

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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}