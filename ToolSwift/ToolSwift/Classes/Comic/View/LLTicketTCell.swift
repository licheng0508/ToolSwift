//
//  LLTicketTCell.swift
//  ToolSwift
//
//  Created by 武汉智驾 on 2017/12/19.
//  Copyright © 2017年 licheng. All rights reserved.
//

import UIKit

class LLTicketTCell: LLBaseTableViewCell {

    var model: DetailRealtimeModel? {
        didSet {
            guard let model = model else { return }
            let text = NSMutableAttributedString(string: "本月月票       |     累计月票  ",
                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                                                              NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
            text.append(NSAttributedString(string: "\(model.comic?.total_ticket ?? "")",
                attributes: [NSAttributedStringKey.foregroundColor: UIColor.orange,
                             NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]))
            text.insert(NSAttributedString(string: "\(model.comic?.monthly_ticket ?? "")",
                attributes: [NSAttributedStringKey.foregroundColor: UIColor.orange,
                             NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]),
                        at: 6)
            textLabel?.attributedText = text
            textLabel?.textAlignment = .center
        }
    }
}
