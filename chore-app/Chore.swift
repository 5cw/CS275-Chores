//
//  Chore.swift
//  chore-app
//
//  Created by Admin on 11/4/21.
//

import Foundation
import UIKit


class Chore : Equatable, Codable {
    
    
    static func == (lhs: Chore, rhs: Chore) -> Bool {
        return lhs === rhs
    }
    
    var title : String
    var period : TimeInterval
    var lastCompleted : Date?
    var turnOrder : [String]
    var units : String
    static let formatter = DateComponentsFormatter()
    static let durationDict = [
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
        self.period = Double(Chore.durationDict[units, default: 0] * num)
        self.turnOrder = [String]()
        self.lastCompleted = nil
        self.units = units
        Chore.formatter.maximumUnitCount = 1
        Chore.formatter.unitsStyle = .full
        Chore.formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour]
    }
    
    func whoseTurn() -> String {
        return turnOrder.isEmpty ? "Nobody" : turnOrder[0]
    }
    
    func completedString() -> String {
        if let since = sinceCompleted, let msg = Chore.formatter.string(from: since) {
            return since > 60 * 60 ? "Last Completed \(msg) ago" : "Last Completed Just Now"
        } else {
            return "Not Yet Completed"
        }
    }
    
    func numberOf() -> Int {
        return Int(period) / (Chore.durationDict[units] ?? 0)
    }

    func complete() -> String {
        lastCompleted = Date()
        guard !turnOrder.isEmpty else { return "Nobody" }
        let removed = turnOrder.remove(at: 0)
        turnOrder.append(removed)
        return removed
    }
    
    func setPeriod(num: Int, units: String?) {
        period = Double(Chore.durationDict[units ?? self.units, default: 0] * num)
        self.units = units ?? self.units
    }

    
}
