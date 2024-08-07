//
//  Statistic.swift
//  Trivia
//
//  Created by Chris Lucas on 28.11.21.
//  Copyright © 2021 HEIA-FR INFO. All rights reserved.
//

import UIKit

class Statistic: Codable {
    var nbGold:Int
    var nbSilver:Int
    var nbBronze:Int
    var completed:Int
    var answered:Int
    var correct:Int
    var rating:Double {
        return (self.answered != 0) ? (Double(self.correct) / Double(self.answered)) * 100.0 : 0.0
    }
    
    init() {
        self.nbGold = 0
        self.nbSilver = 0
        self.nbBronze = 0
        self.completed = 0
        self.answered = 0
        self.correct = 0
    }
    
    init(nbGold:Int, nbSilver:Int, nbBronze:Int, completed:Int, answered:Int, correct:Int) {
        self.nbGold = nbGold
        self.nbSilver = nbSilver
        self.nbBronze = nbBronze
        self.completed = completed
        self.answered = answered
        self.correct = correct
    }
}
