//
//  Data+.swift
//  Trivia
//
//  Created by Chris Lucas on 07.09.20.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import Foundation

//
// Extension : Data
//
// Description : This extension allows to remove the html characters of a String. This extensions needs another extension in the file StringProtocl+ to work properly.
//
// Usage : <your_string_variable>.html2String
//
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}
