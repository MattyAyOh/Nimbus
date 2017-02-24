//
//  UserDefaultsHandler.swift
//  Nimbus
//
//  Created by Michael Anderson on 2/14/17.
//  Copyright © 2017 Michael Anderson. All rights reserved.
//

import UIKit

//Player info
public var userIDDefaults: String = "userIDDefaults"
public var userNicknameDefaults: String = "userNicknameDefaults"


class UserDefaultsHandler {
    
    static func uniqueID() -> String {
        var id  = UserDefaults().string(forKey: userIDDefaults)
        
        if id == nil {
            id = UUID().uuidString
            UserDefaults().set(id, forKey: userIDDefaults)
        }
        
        return id!
    }
    
    static func userNickname() -> String? {
        return UserDefaults().string(forKey: userNicknameDefaults)
    }
    
    static func promptForUserNickname(_ currentViewController: UIViewController) {
        let alertController = UIAlertController(title: "Enter Nickname", message: "Nickname will be displayed in game lobbies", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            if let alertController = alertController {
                let nicknameTextField = alertController.textFields![0] as UITextField
                UserDefaults().set(nicknameTextField.text, forKey: userNicknameDefaults)
            }
        }
        okAction.isEnabled = false
        
        alertController.addTextField { textField in
            textField.placeholder = "Nickname"
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { notification in
                okAction.isEnabled = textField.text != ""
            }
        }
        
        alertController.addAction(okAction)

        currentViewController.present(alertController, animated: true) {
            //Handled by OK
        }
    }

}
