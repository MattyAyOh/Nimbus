//
//  CreateLobbyViewController.swift
//  Nimbus
//
//  Created by Michael Anderson on 2/18/17.
//  Copyright © 2017 Michael Anderson. All rights reserved.
//

import UIKit

class CreateLobbyViewController: UIViewController  {

    @IBOutlet weak var gameNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var gameTypeTextField: UITextField!
    @IBOutlet weak var skillLevelTextField: UITextField!
    @IBOutlet weak var createLobbyButton: UIButton!
    
    let typeArray = ["川麻", "普通"]
    let skillArray = ["None", "Beginner", "Intermediate", "Expert"]
    
    var typePicker: PickerArrayController?
    var skillPicker: PickerArrayController?
    let lobby = Lobby()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skillLevelTextField.text = skillArray[0]
        gameTypeTextField.text = typeArray[0]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateLobbyViewController.checkValidLobby), name: NSNotification.Name.UITextFieldTextDidChange, object: gameNameTextField)
        
        checkValidLobby()
    }
    
    func checkValidLobby() {
        var enabled = false
        if let emptyName = gameNameTextField.text?.isEmpty,
            let emptyDate = dateTextField.text?.isEmpty {
            enabled = !emptyName && !emptyDate
        }
        createLobbyButton.isEnabled = enabled
        createLobbyButton.alpha = enabled ? 1.0 : 0.5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func editDate(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        
        datePickerView.minimumDate = Date()
        datePickerView.minuteInterval = 5
        datePickerView.datePickerMode = .dateAndTime
        
        datePickerView.setDate(lobby.startTime, animated: false)
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(CreateLobbyViewController.datePickerValueChanged), for: .valueChanged)
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
        
        lobby.startTime = sender.date
        
        dateTextField.text = dateFormatter.string(from: sender.date)
        checkValidLobby()
    }
    
    @IBAction func editGameType(_ sender: UITextField) {
        let numberPicker = UIPickerView()
        
        typePicker = PickerArrayController(typeArray, gameTypeTextField)
        
        numberPicker.delegate = typePicker
        numberPicker.dataSource = typePicker
        
        if let currentText = gameTypeTextField.text,
            let index = typeArray.index(of: currentText) {
            numberPicker.selectRow(index, inComponent: 0, animated: false)
        }
        
        sender.inputView = numberPicker
    }
    
     @IBAction func editSkillLevel(_ sender: UITextField) {
        let skillLevelPickerView = UIPickerView()
        
        skillPicker = PickerArrayController(skillArray, skillLevelTextField)
        
        skillLevelPickerView.delegate = skillPicker
        skillLevelPickerView.dataSource = skillPicker
        
        if let currentText = skillLevelTextField.text,
            let index = skillArray.index(of: currentText) {
            skillLevelPickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
        sender.inputView = skillLevelPickerView
    }
    

    @IBAction func createPressed(_ sender: Any) {
        lobby.gameName = gameNameTextField.text
        
//        if let playerCount = playerCountTextField.text {
//            if let playerCountInt = Int(playerCount) {
//                lobby.maxPlayerSize = playerCountInt
//            }
//        }
        
        CloudHandler.shared.createLobby(lobby) { record, error in
            if let record = record {
                self.lobby.identifier = record.recordID
                print(record)
            } else if let error = error {
                print(error)
            }
        }
        
        dismiss(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
