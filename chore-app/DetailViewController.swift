//
//  ViewController.swift
//  chore-app
//
//  Created by Lexi Reinsborough on 11/7/21.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate {
    let times = ["Hour", "Day", "Week", "Month", "Year"]
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var titleField: UITextField!
    var chore: Chore!
    var cell: ChoreCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = chore.title
        titleField.tag = 0
        numberField.tag = 1
        numberField.text = String(chore.numberOf())
        picker.selectRow(times.firstIndex(of: chore.units) ?? 0, inComponent: 0, animated: false)
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
        chore.units = times[row]
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 || string.isEmpty {return true}
        return string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            chore.title = textField.text ?? "None"
        } else if textField.tag == 1 {
            chore.setPeriod(num: Int(textField.text!)!, units: nil)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
    }
}
