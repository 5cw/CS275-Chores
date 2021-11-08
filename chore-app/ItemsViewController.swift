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
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            choreStore.allChores.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moved = choreStore.allChores.remove(at: sourceIndexPath.row)
        choreStore.allChores.insert(moved, at: destinationIndexPath.row)
        
    }
    
    @IBAction func addNewItem(_ sender: UIButton) {
        let path = IndexPath(row: choreStore.allChores.count, section: 0)
        choreStore.newChore("Croquet", 2, "Days")
        tableView.insertRows(at: [path], with: .automatic)
        
    }

    @IBAction func toggleEditingMode(_ sender: UIButton) {
        setEditing(!isEditing, animated: true)
        
        sender.setTitle(isEditing ? "Done" : "Edit", for: .normal)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "showChore":
                // Figure out which row was just tapped
                if let row = tableView.indexPathForSelectedRow?.row {
                    let chore = choreStore.allChores[row]
                    let detailViewController = segue.destination as! DetailViewController
                    detailViewController.chore = chore
                    detailViewController.cell = sender as! ChoreCell
                    
                }
            default:
                preconditionFailure("Unexpected segue identifier.")
            }
        print("run")
    }

}
