//
//  ProfileViewModel.swift
//  Trivia
//
//  Created by Chris Lucas on 04.11.21.
//  Copyright © 2021 HEIA-FR INFO. All rights reserved.
//

import Foundation

class ProfileViewModel {
    
    init() {
        
    }
    
    func saveStatistic(statistic:Statistic) {
        StatisticData.shared.save(statistic: statistic)
    }
    
    func fetchStatistic() -> Statistic {
        return StatisticData.shared.fetch()
    }
}
