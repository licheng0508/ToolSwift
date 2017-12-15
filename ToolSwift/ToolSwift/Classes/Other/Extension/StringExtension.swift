//
//  StringExtension.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/14.
//  Copyright © 2017年 licheng. All rights reserved.
//

import Foundation

extension String {
    
    /// 字符串操作
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    /// 当前字符串是否是手机号
    func isPhoneNum() -> Bool {
        
        if self.hasPrefix("1") && self.count == 11 {
            return self.isNumber()
        }
        return false
    }
    
    /// 当前字符串是否是数字
    func isNumber() -> Bool {
        
        let number = "^[0-9]*$"
        let regexNumber = NSPredicate(format: "SELF MATCHES %@",number)
        
        return regexNumber.evaluate(with: self)
    }
}

