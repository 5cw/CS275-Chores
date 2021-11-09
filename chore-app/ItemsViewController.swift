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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        choreStore.saveChanges()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choreStore.allChores.count
    }
    	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chore", for: indexPath) as! ChoreCell
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
        if editingStyle == .delete {
            choreStore.allChores.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moved = choreStore.allChores.remove(at: sourceIndexPath.row)
        choreStore.allChores.insert(moved, at: destinationIndexPath.row)
        
    }

    @IBAction func toggleEditingMode(_ sender: UIButton) {
        setEditing(!isEditing, animated: true)
        
        sender.setTitle(isEditing ? "Done" : "Edit", for: .normal)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.choreStore = choreStore
        switch segue.identifier {
            case "showChore":
                if let row = tableView.indexPathForSelectedRow?.row {
                    let chore = choreStore.allChores[row]
                    detailViewController.chore = chore
                }
            case "add":
                let c = choreStore.newChore("Chore Name", 1, "Week")
                detailViewController.chore = c
            default:
                preconditionFailure("Unexpected segue identifier.")
            }
        print("run")
    }

}
