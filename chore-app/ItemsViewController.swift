//
//  ItemsViewController.swift
//  chore-app
//
//  Created by Admin on 11/4/21.
//

import Foundation
import UIKit

class ItemsViewController: UITableViewController {
    var choreStore: ChoreStore!
    var roommateStore: RoommateStore!
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choreStore.allChores.count
    }
    	
    override func tableView(_ tableView: UITableView,
            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell with default appearance
        let cell = tableView.dequeueReusableCell(withIdentifier: "chore", for: indexPath) as! ChoreCell

        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the table view
        let chore = choreStore.allChores[indexPath.row]

        cell.title?.text = chore.title
        cell.turn?.text = "\(chore.whoseTurn())'s Turn"
        cell.completed?.text = chore.completedString()
        cell.completed?.textColor = chore.isOverdue ? .red : .black

        return cell
    }
    
    @IBAction func addNewItem(_ sender: UIButton) {

    }

    @IBAction func toggleEditingMode(_ sender: UIButton) {
        setEditing(!isEditing, animated: true)
        sender.setTitle(isEditing ? "Done" : "Edit", for: .normal)
    }
}
