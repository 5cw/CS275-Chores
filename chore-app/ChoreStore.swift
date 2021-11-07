//
//  ChoreStore.swift
//  chore-app
//
//  Created by Lexi Reinsborough on 11/6/21.
//

import Foundation
class ChoreStore {
    var allChores = [Chore]()
    
    @discardableResult func newChore(_ title: String, _ period: TimeInterval) -> Chore {
        var newR = Chore(title: title, period: period)
        allChores.append(newR)
        return newR
    }
}
