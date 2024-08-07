//
//  StringProtocol+.swift
//  Trivia
//
//  Created by Chris Lucas on 07.09.20.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import Foundation

//
// Extension : StringProtocol
//
// Description : This extension allows to remove the html characters of a String. This extensions needs another extension in the file Data+ to work properly.
//
// Usage : <your_string_variable>.html2String
//
extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
