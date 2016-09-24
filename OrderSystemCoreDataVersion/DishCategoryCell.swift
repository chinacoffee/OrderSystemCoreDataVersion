//
//  DishCategoryCell.swift
//  OrderSystemCoreDataVersion
//
//  Created by Xiaoguang Shi on 21/9/16.
//  Copyright © 2016 Xiaoguang Shi. All rights reserved.
//

import UIKit

class DishCategoryCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
   
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var aliasLabel: UILabel!
    
    func configureCell(dishCategory: DishCategory) {
    
        self.titleLabel.text = dishCategory.title
        self.aliasLabel.text = dishCategory.alias
        self.thumb.layer.cornerRadius = 30
        self.thumb.layer.masksToBounds = true
        self.thumb.layer.borderWidth = 1
        self.thumb.layer.borderColor = UIColor.black.cgColor
        
        if let img = dishCategory.image as? UIImage {
            self.thumb.image = img
        } else {
            self.thumb.image = nil
        }
        
    }
    
}
