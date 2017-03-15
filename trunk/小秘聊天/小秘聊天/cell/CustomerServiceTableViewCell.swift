//
//  CustomerServiceTableViewCell.swift
//  小秘聊天
//
//  Created by LiWeijie on 2017/3/14.
//  Copyright © 2017年 WeijieLi. All rights reserved.
//

import UIKit

class CustomerServiceTableViewCell: UITableViewCell {

    @IBOutlet var answerLabel: UILabel!
    
    @IBOutlet var answerBackImage: UIImageView!
    
    @IBOutlet var abackWidth: NSLayoutConstraint!
    
    @IBOutlet var abackHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
