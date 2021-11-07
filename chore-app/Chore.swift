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
    var turnOrder : [String]
    var formatter = DateComponentsFormatter()
    
    var sinceCompleted : TimeInterval? {
        get{
            return lastCompleted?.timeIntervalSinceNow
        }
    }
    
    var isOverdue : Bool {
        if let since = sinceCompleted {
            return since > period
        } else {
            return true
        }
    }
    
    init (title : String, period: TimeInterval){
        self.title = title
        self.period = period
        self.turnOrder = [String]()
        self.lastCompleted = nil
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day]
    }
    
    func whoseTurn() -> String {
        return turnOrder.isEmpty ? "Nobody" : turnOrder[0]
    }
    
    func completedString() -> String {
        if let since = sinceCompleted, let msg = formatter.string(from: since) {
            return msg
        } else {
            return "Not Yet Completed"
        }
    }
    
    func complete() {
        lastCompleted = Date()
        guard turnOrder.isEmpty else { return }
        let removed = turnOrder.remove(at: 0)
        turnOrder.append(removed)
    }
    
}
