//
//  StatisticData.swift
//  Trivia
//
//  Created by Chris Lucas on 25.11.21.
//  Copyright © 2021 HEIA-FR INFO. All rights reserved.
//

import UIKit
import CoreData

class StatisticData {
    
    static var shared = StatisticData()
    
    init() {
        
    }
    
    func save(statistic:Statistic) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(statistic)
            UserDefaults.standard.set(data, forKey: "statistic")
            UserDefaults.standard.synchronize()
        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
    }
    
    func fetch() -> Statistic {
        var statistic:Statistic?
        if let data = UserDefaults.standard.data(forKey: "statistic") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                statistic = try decoder.decode(Statistic.self, from: data)
            } catch {
                print("Unable to Decode Statistic (\(error))")
            }
        } else {
            statistic = Statistic()
            self.save(statistic: statistic!)
        }
        return statistic!
    }
}
