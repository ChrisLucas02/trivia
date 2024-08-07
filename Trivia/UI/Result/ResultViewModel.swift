//
//  ResultViewModel.swift
//  Trivia
//
//  Created by Chris Lucas on 04.11.21.
//  Copyright © 2021 HEIA-FR INFO. All rights reserved.
//

import Foundation
import Combine
import UIKit

class ResultViewModel : ObservableObject {
    
    @Published private(set) var medal:MedalType?
    @Published private(set) var message:String?
    
    private var subscriptions:Set<AnyCancellable> = []



    init(){
        
    }
    
    func getNbQuestions() -> Int {
        return TriviaRepository.shared.nbQuestions
    }
    
    func getScore() ->Int {
        return TriviaRepository.shared.score
    }
    
    func determineMedal(){
        TriviaRepository.shared.$medal.sink { [unowned self]result in
            if result != nil {
                self.medal = result
            }
        }.store(in: &subscriptions)
        TriviaRepository.shared.$message.sink { [unowned self]result in
            if result != nil {
                self.message = result
            }
        }.store(in: &subscriptions)
    }
    
    func resetGame() {
        TriviaRepository.shared.resetGame()
    }
    
    func saveStats() {
        TriviaRepository.shared.saveStatistic()
    }
}
