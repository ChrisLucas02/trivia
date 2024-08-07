//
//  Questions.swift
//  Trivia
//
//  Created by Chris Lucas on 11.11.21.
//  Copyright © 2021 HEIA-FR INFO. All rights reserved.
//

import UIKit

class TriviaQuestions: Decodable {
    var response_code: Int
    var results: [Question]
}
