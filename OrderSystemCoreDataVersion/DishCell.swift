//
//  DishCell.swift
//  OrderSystemCoreDataVersion
//
//  Created by Xiaoguang Shi on 23/9/16.
//  Copyright © 2016 Xiaoguang Shi. All rights reserved.
//

import UIKit

class DishCell: UITableViewCell {

    
    @IBOutlet weak var thumb: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var aliasLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    func configureCell(dish: Dish) {
        
        self.titleLabel.text = dish.title
        self.aliasLabel.text = dish.alias
        self.detailLabel.text = dish.detail
        self.priceLabel.text = "$" + String(format: "%.2f", dish.price)
        self.thumb.layer.cornerRadius = 30
        self.thumb.layer.masksToBounds = true
        self.thumb.layer.borderWidth = 1
        self.thumb.layer.borderColor = UIColor.black.cgColor
        
        if let img = dish.image as? UIImage {
            self.thumb.image = img
        }
        
    }
    
}
