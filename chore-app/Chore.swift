//
//  Chore.swift
//  chore-app
//
//  Created by Admin on 11/4/21.
//

import Foundation
import UIKit


class Chore : Equatable {
    
    static func == (lhs: Chore, rhs: Chore) -> Bool {
        return lhs === rhs
    }
    
    var title : String
    var period : TimeInterval
    var lastCompleted : Date?
    var turnOrder : [String]
    var units : String
    let formatter = DateComponentsFormatter()
    let durationDict = [
        "Year"  : 60 * 60 * 24 * 365,
        "Month" : 60 * 60 * 24 * 30,
        "Week"  : 60 * 60 * 24 * 7,
        "Day"   : 60 * 60 * 24,
        "Hour"  : 60 * 60
    ]
    
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
    
    init (title : String, num: Int, units: String){
        self.title = title
        self.period = Double(durationDict[units, default: 0] * num)
        self.turnOrder = [String]()
        self.lastCompleted = nil
        self.units = units
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour]
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
    
    func numberOf() -> Int {
        return Int(period) / (durationDict[units] ?? 0)
    }

    func complete() {
        lastCompleted = Date()
        guard turnOrder.isEmpty else { return }
        let removed = turnOrder.remove(at: 0)
        turnOrder.append(removed)
    }
    
    func setPeriod(num: Int, units: String?) {
        period = Double(durationDict[units ?? self.units, default: 0] * num)
    }
    
}
