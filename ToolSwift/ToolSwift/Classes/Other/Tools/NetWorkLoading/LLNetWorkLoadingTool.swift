//
//  LLNetWorkLoadingTool.swift
//  HnR
//
//  Created by licheng on 2017/8/15.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LLNetWorkLoadingTool: UIViewController, NVActivityIndicatorViewable {

    /// 单例
    static let sharedInstance = LLNetWorkLoadingTool()

    /// 开始加载
    func loadingStarAnimation() {

        startAnimating(CGSize(width: 30, height: 30), type: NVActivityIndicatorType.lineScale, color: UIColor.darkGray, backgroundColor: UIColor.clear)

    }

    /// 结束加载
    func loadingStopAnimation() {

        self.stopAnimating()
    }
}

