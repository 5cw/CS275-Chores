//
//  ViewController.swift
//  chore-app
//
//  Created by Lexi Reinsborough on 11/7/21.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let times = ["Hour", "Day", "Week", "Month", "Year"]
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var turnLabel: UILabel!
    var chore: Chore!
    var choreStore: ChoreStore!
    var offDuty: [String] {
        let out = choreStore.allRoommates.filter {!chore.turnOrder.contains($0)}
        return out
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = chore.title
        titleField.tag = 0
        numberField.tag = 1
        numberField.text = String(chore.numberOf())
        picker.selectRow(times.firstIndex(of: chore.units) ?? 0, inComponent: 0, animated: false)
        table.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        updateDateLabel()
        updateTurnLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }
    
    func updateDateLabel(){
        let lastString : String
        let dueString : String
        let nowString = "Right Now: " + DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        if let d = chore.lastCompleted {
            lastString = "Last Completed: " + DateFormatter.localizedString(from: d, dateStyle: .medium, timeStyle: .short)
            let due = d.addingTimeInterval(chore.period)
            dueString = "Due: " + DateFormatter.localizedString(from: due, dateStyle: .medium, timeStyle: .short)
        } else {
            lastString = "Not Yet Completed"
            dueString = "Due ASAP"
        }
        
        dateLabel.text = "\(nowString)\n\(lastString)\n\(dueString)"
        dateLabel.textColor = chore.isOverdue ? .red : .black
        updateTurnLabel()
    }
    
    func updateTurnLabel(){
        var turn = "\(chore.whoseTurn())'s Turn"
        if chore.isOverdue {
            turn = turn + " !"
            turnLabel.textColor = .red
        } else {
            turnLabel.textColor = .black
        }
        turnLabel.text = turn
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(times[row])s"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chore.setPeriod(num: Int(numberField.text!) ?? 1, units: times[row])
        updateDateLabel()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {return true}
        chore.setPeriod(num: Int(textField.text!) ?? 1, units: nil)
        updateDateLabel()
        return string.isEmpty || string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            chore.title = textField.text ?? "None"
        } else if textField.tag == 1 {
            chore.setPeriod(num: Int(textField.text!) ?? 1, units: nil)
        }
        updateDateLabel()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return chore.turnOrder.count
            case 1:
                return offDuty.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return "On Duty"
            case 1:
                return "Off Duty"
            default:
                return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "roommate", for: indexPath)
        var config = c.defaultContentConfiguration()
        switch indexPath.section {
        case 0:
            config.text = chore.turnOrder[indexPath.row]
        case 1:
            config.text = offDuty[indexPath.row]
        default:
            config.text = "nil"
        }
        c.contentConfiguration = config
        return c
    }
    
    func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        switch indexPath.section {
        case 0:
            chore.turnOrder.remove(at: indexPath.row)
        case 1:
            let n = offDuty[indexPath.row]
            choreStore.allRoommates.remove(at: choreStore.allRoommates.firstIndex(of: n)!)
        default:
            preconditionFailure("Invalid section")
        }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateTurnLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        switch (sourceIndexPath.section, destinationIndexPath.section) {
        case (0, _):
            let rm = chore.turnOrder.remove(at: sourceIndexPath.row)
            if destinationIndexPath.section == 0 {
                chore.turnOrder.insert(rm, at: destinationIndexPath.row)
            }
        case (1, 0):
            let rm = offDuty[sourceIndexPath.row]
            chore.turnOrder.insert(rm, at: destinationIndexPath.row)
        default:
            let toMove = choreStore.allRoommates.firstIndex(of: offDuty[sourceIndexPath.row]) ?? 0
            let afterString = offDuty[destinationIndexPath.row]
            let rm = choreStore.allRoommates.remove(at: toMove)
            let after = choreStore.allRoommates.firstIndex(of: afterString) ?? 0
            choreStore.allRoommates.insert(rm, at: after + 1)
        }
        updateTurnLabel()
        
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        table.setEditing(!table.isEditing, animated: true)
        
        sender.setTitle(table.isEditing ? "Done" : "Edit", for: .normal)
        
    }
    
    @IBAction func addRoommate(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add New Roommate", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields?[0], let userText = textField.text else { return }
            self.choreStore.newRoommate(userText)
            self.table.reloadData()
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func complete(_ sender: UIButton){
        let completer = chore.complete()
        updateDateLabel()
        table.reloadData()
        let alert = UIAlertController(title:"\(chore.title) completed. Thanks, \(completer)! It's \(chore.whoseTurn())'s turn now.", message:nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}
