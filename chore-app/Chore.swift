//
//  Chore.swift
//  chore-app
//
//  Created by Admin on 11/4/21.
//

import Foundation
import UIKit

class Chore {
    var title : String
    var period : TimeInterval
    var lastCompleted : Date?
    var turnOrder : [Roommate]
    
    init (title : String, period: TimeInterval, turnOrder: [Roommate]){
        self.title = title
        self.period = period
        self.turnOrder = turnOrder
        self.lastCompleted = nil
    }
}
