//
//  CustomUIButton.swift
//  Trivia
//
//  Created by Chris Lucas on 07.09.20.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import UIKit

//
// Class : AnswerButton
// Superclass : UIButton
//
// Description : Customised button that changes its background color when highlighted
//
// Usage : set AnswerButton to the Button in the identity inspector of the storyboard
//
class AnswerButton: UIButton {
    
    private let customLightGrayValue = CGFloat(0xE0 / 255.0)

    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = UIColor(red: customLightGrayValue, green: customLightGrayValue, blue: customLightGrayValue, alpha: 1.0)
            } else {
                if !(backgroundColor == UIColor.green || backgroundColor == UIColor.red) {
                    backgroundColor = nil
                }
            }
        }
    }
    
}

//
// Class : ListButton
// Superclass : UIButton
//
// Description : Customised button that changes its background color when highlighted
//
// Usage : set ListButton to the Button in the identity inspector of the storyboard
//
class ListButton: UIButton {
    
    private let customLightGrayValue = CGFloat(0xE0 / 255.0)

    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = UIColor(red: customLightGrayValue, green: customLightGrayValue, blue: customLightGrayValue, alpha: 1.0)
            } else {
                backgroundColor = nil
            }
        }
    }
    
}
