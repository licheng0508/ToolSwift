//
//  LLBoutiqueListViewController.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/14.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLBoutiqueListViewController: LLBaseViewController {

    private var sexType: Int = UserDefaults.standard.integer(forKey: String.sexTypeKey)
    private var galleryItems = [GalleryItemModel]()
    private var TextItems = [TextItemModel]()
    private var comicLists = [ComicListModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData(showloading: true)
    }
    
    /// 获取数据
    private func loadData(_ changeSex: Bool = false, showloading: Bool){
    
        if changeSex {
            sexType = 3 - sexType
            UserDefaults.standard.set(sexType, forKey: String.sexTypeKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: .USexTypeDidChange, object: nil)
        }
        
        ApiToolProvider(showloading).request(ApiTool.boutiqueList(sexType: sexType), model: BoutiqueListModel.self) { [weak self] (returnData) in
            
            self?.galleryItems = returnData?.galleryItems ?? []
            self?.TextItems = returnData?.textItems ?? []
            self?.comicLists = returnData?.comicLists ?? []
        }
    }
}
