//
//  MBProgressHUDTool.swift
//  HnR
//
//  Created by licheng on 2017/7/27.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit
import MBProgressHUD

// MARK: - 私有方法/变量

private let view = UIApplication.shared.keyWindow

/// 初始化
private func setupMBProgressHUD(message: String?, mode: MBProgressHUDMode) {
    
    
    if let view = view {
        
        let hub : MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        hub.label.text = message
        hub.label.font = UIFont.systemFont(ofSize: 21)
        hub.mode = mode

        //样式
        hub.bezelView.color = UIColor.black
        hub.contentColor = UIColor.white
        
        switch mode {
        case .text:
            setupDetailsLabel(hub: hub, message: message)
        default: break
        }
    }
}

private func setupDetailsLabel(hub: MBProgressHUD, message: String?) {
    
    //显示文本2秒后自动隐藏
    hub.label.text = nil
    hub.detailsLabel.text = message;
    hub.detailsLabel.font = UIFont.systemFont(ofSize: 21)
    hub.hide(animated: true, afterDelay: HUD_SHOW_TEXT_SECOND)
}

// MARK: - 外部控制方法

/// 文本弹框
func MBProgressHUDShowText(_ message: String?) {
    
    if let message = message {
        setupMBProgressHUD(message: message, mode: .text)
    }
}

/// 网络加载弹框
func MBProgressHUDShowNetWorkLoading(_ message: String? = "加载中...") {
    
    setupMBProgressHUD(message: message, mode: .indeterminate)
    
}

/// 隐藏HUB
func MBProgressHUDHide() {
    
    if let view = view {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
