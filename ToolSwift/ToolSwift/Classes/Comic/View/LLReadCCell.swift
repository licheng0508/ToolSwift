//
//  LLReadCCell.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/19.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView: Placeholder {}

class LLReadCCell: LLBaseCollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFit
        return iw
    }()
    
    lazy var placeholder: UIImageView = {
        let pr = UIImageView(image: UIImage(named: "yaofan"))
        pr.contentMode = .center
        return pr
    }()
    
    override func configUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    var model: ImageModel? {
        didSet {
            guard let model = model else { return }
            imageView.image = nil
            imageView.kf.setImage(urlString: model.location, placeholder: placeholder)
        }
    }
}

