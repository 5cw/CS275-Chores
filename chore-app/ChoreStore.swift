//
//  ChoreStore.swift
//  chore-app
//
//  Created by Lexi Reinsborough on 11/6/21.
//

import Foundation
import UIKit

class ChoreStore {
    var allChores = [Chore]()
    public var allRoommates = [String]()
    
    let choreArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("chores.plist")
    }()
    let roommateArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("roommates.plist")
    }()
    
    init(){
        do {
                let dataC = try Data(contentsOf: choreArchiveURL)
                let dataR = try Data(contentsOf: roommateArchiveURL)
                let unarchiver = PropertyListDecoder()
                let c = try unarchiver.decode([Chore].self, from: dataC)
                let r = try unarchiver.decode([String].self, from: dataR)
            allChores = c
            allRoommates = r
            } catch {
                print("Error reading in saved chores and roommates: \(error)")
            }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.willDeactivateNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didDisconnectNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    @discardableResult func newChore(_ title: String, _ num: Int, _ units: String) -> Chore {
        let newC = Chore(title: title, num: num, units: units)
        allChores.append(newC)
        return newC
    }
    
    @discardableResult func newRoommate(_ name: String) -> String{
        var n = name
        var i = 0
        while allRoommates.contains(n) {
            n = "\(n)\(i)"
            i += 1
        }
        allRoommates.append(n)
        return n
    }
    
    @objc @discardableResult func saveChanges() -> Bool {
            do {
                let encoder = PropertyListEncoder()
                let dataC = try encoder.encode(allChores)
                try dataC.write(to: choreArchiveURL, options: [.atomic])
                let dataR = try encoder.encode(allRoommates)
                try dataR.write(to: roommateArchiveURL, options: [.atomic])
                print("Saved all of the chores and roommates")
                return true
            } catch let encodingError {
                print("Error encoding chores and roommates: \(encodingError)")
                return false
            }
    }
}
