//
//  HelpTool.swift
//  HnR
//
//  Created by licheng on 2017/7/27.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher
import SnapKit
import MJRefresh

extension UIColor {
    
    class var background: UIColor {
        return UIColor(r: 242, g: 242, b: 242)
    }
    
    class var theme: UIColor {
        return UIColor(r: 29, g: 221, b: 43)
    }
}

extension String {
    static let searchHistoryKey = "searchHistoryKey"
    static let sexTypeKey = "sexTypeKey"
}

//MARK: swizzledMethod
extension NSObject {
    
    static func swizzleMethod(_ cls: AnyClass, originalSelector: Selector, swizzleSelector: Selector){
        
        let originalMethod = class_getInstanceMethod(cls, originalSelector)!
        let swizzledMethod = class_getInstanceMethod(cls, swizzleSelector)!
        let didAddMethod = class_addMethod(cls,
                                           originalSelector,
                                           method_getImplementation(swizzledMethod),
                                           method_getTypeEncoding(swizzledMethod))
        if didAddMethod {
            class_replaceMethod(cls,
                                swizzleSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

//MARK: SnapKit
extension ConstraintView {
    
    var usnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        } else {
            return self.snp
        }
    }
}


/// 自定义LOG的目的:
/// 在开发阶段自动显示LOG
/// 在发布阶段自动屏蔽LOG
///
/// print(__FUNCTION__)   打印所在的方法
/// print(__LINE__)      打印所在的行
/// print(__FILE__)      打印所在文件的路径
///
/// 方法名称[行数]: 输出内容
func LLPrint<T>(_ message: T, method: String = #function, line: Int = #line, file: String = #file)
{
    #if DEBUG
        
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        let logStr = "\(fileName)-\(method)[\(line)]: \(message)"
        print(logStr)
        
    #endif
}

