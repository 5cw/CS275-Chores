//
//  RoommateStore.swift
//  chore-app
//
//  Created by Lexi Reinsborough on 11/6/21.
//

import Foundation

class RoommateStore {
    var allRoommates = [String]()
    
    @discardableResult func newRoommate(_ name: String) -> String {
        allRoommates.append(name)
        return name
    }
    
}
