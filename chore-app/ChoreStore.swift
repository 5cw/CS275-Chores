//
//  ChoreStore.swift
//  chore-app
//
//  Created by Lexi Reinsborough on 11/6/21.
//

import Foundation
class ChoreStore {
    var allChores = [Chore]()
    
    @discardableResult func newChore(_ title: String, _ num: Int, _ units: String) -> Chore {
        var newR = Chore(title: title, num: num, units: units)
        allChores.append(newR)
        return newR
    }
}
