//
//  CategoryTableViewCell.swift
//  Trivia
//
//  Created by Chris Lucas on 14.08.20.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    var actionBlock: (() -> Void)? = nil
    
    @IBOutlet weak var category: UIButton!
    @IBOutlet weak var card: UIView!
    
    @IBAction func categoryClicked(_ sender: UIButton) {
        actionBlock?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        card.layer.shadowColor = UIColor.gray.cgColor
        card.layer.shadowOpacity = 1
        card.layer.shadowOffset = .zero
        card.layer.shadowRadius = 3
        card.layer.shouldRasterize = true
    }

}
