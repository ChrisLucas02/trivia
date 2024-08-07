//
//  HistoryTableViewModel.swift
//  Trivia
//
//  Created by Chris Lucas on 04.11.21.
//  Copyright © 2021 HEIA-FR INFO. All rights reserved.
//

import Foundation

class HistoryTableViewModel  {
    
    init() {
        
    }
    
    func getDataDB() -> [Question] {
        return CoreDataManager.shared.fetchQuestions()
    }

}
