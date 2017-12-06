//
//  HelpTool.swift
//  HnR
//
//  Created by licheng on 2017/7/27.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

/*
 自定义LOG的目的:
 在开发阶段自动显示LOG
 在发布阶段自动屏蔽LOG
 
 print(__FUNCTION__)  // 打印所在的方法
 print(__LINE__)     // 打印所在的行
 print(__FILE__)     // 打印所在文件的路径
 
 方法名称[行数]: 输出内容
 */
func LLPrint<T>(_ message: T, method: String = #function, line: Int = #line, file: String = #file)
{
    #if DEBUG
        
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        let logStr = "\(fileName)-\(method)[\(line)]: \(message)"
        print(logStr)
        
    #endif
}

/// 获取屏幕宽度
func getMainScreenWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}
/// 获取屏幕高度
func getMainScreenHeight() -> CGFloat {
    return UIScreen.main.bounds.height
}

/// 返回颜色
func UIColorWithRed(_ red: Float, green: Float, blue: Float, alpha: Float? = 1.0) -> UIColor {

    return UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: CGFloat(alpha!))
}

