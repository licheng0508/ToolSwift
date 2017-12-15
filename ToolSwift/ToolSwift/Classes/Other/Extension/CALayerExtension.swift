//
//  CALayerExtension.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/15.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

extension CALayer {
    
    /// xib中设置view边框颜色
    var borderColorFromUIColor: UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        }
        
        set (color) {
            self.borderColor = color.cgColor
        }
    }
}
