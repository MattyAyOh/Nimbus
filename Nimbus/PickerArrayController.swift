//
//  PickerArrayController.swift
//  Nimbus
//
//  Created by Michael Anderson on 2/18/17.
//  Copyright © 2017 Michael Anderson. All rights reserved.
//

import UIKit

class PickerArrayController: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let pickerArray: [String]
    let textField: UITextField
    
    init(_ pickerArray: [String], _ textField: UITextField) {
        self.pickerArray = pickerArray
        self.textField = textField
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = pickerArray[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }

}
