//
//  RoommateStore.swift
//  chore-app
//
//  Created by Lexi Reinsborough on 11/6/21.
//

import Foundation
import UIKit

class RoommateStore {
    var allRoommates = [String]()
    
    let archiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("roommates.plist")
    }()
    
    init(){
        do {
                let data = try Data(contentsOf: archiveURL)
                let unarchiver = PropertyListDecoder()
                let items = try unarchiver.decode([String].self, from: data)
                allRoommates = items
            } catch {
                print("Error reading in saved items: \(error)")
            }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.willDeactivateNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didDisconnectNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    @discardableResult func newRoommate(_ name: String) -> String {
        var n = name
        var suf = 0
        while allRoommates.contains(n){
            n = "\(n)\(suf)"
            suf += 1
        }
        allRoommates.append(n)
        return n
    }
    
    @objc @discardableResult func saveChanges() -> Bool {
        print("Saving items to: \(archiveURL)")
            do {
                let encoder = PropertyListEncoder()
                let data = try encoder.encode(allRoommates)
                try data.write(to: archiveURL, options: [.atomic])
                print("Saved all of the items")
                return true
            } catch let encodingError {
                print("Error encoding allItems: \(encodingError)")
                return false
            }
    }
    
}
