//
//  LobbyViewController.swift
//  Nimbus
//
//  Created by Michael Anderson on 1/30/17.
//  Copyright © 2017 Michael Anderson. All rights reserved.
//

import UIKit
import CloudKit

class LobbyViewController: UIViewController {

    @IBOutlet weak var lobbyTableView: UITableView!
    
    let refresh = UIRefreshControl()
    var lobbies = [Lobby]()
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       // CloudHandler.shared.loginToICloud()
        
        //Setup Table View reusable cells
        let cellNib = UINib(nibName: LobbyTableViewCell.nibName, bundle: nil)
        lobbyTableView.register(cellNib, forCellReuseIdentifier: LobbyTableViewCell.reuseIdentifier)
        lobbyTableView.tableFooterView = UIView()
        
        //Setup refresh control
        refresh.tintColor = UIColor.black
        refresh.addTarget(self, action: #selector(LobbyViewController.fetchAllLobbies), for: .valueChanged)
        lobbyTableView.addSubview(refresh)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CloudHandler.shared.isICloudContainerAvailable { (signedIn) in
            if !signedIn {
                let alertController = UIAlertController(title: "iCloud Required", message: "Please Sign in to iCloud to continue.", preferredStyle: .alert)
                
                let settings = UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                    let settingsCloudKitUrl = URL(string:"App-Prefs:root=CASTLE")
                    if let url = settingsCloudKitUrl {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                })
                alertController.addAction(settings)
                
                self.present(alertController, animated: true, completion: {
                    
                })
            }
        }
        
        //Prompt for nickname if one isn't created
        if UserDefaultsHandler.userNickname() == nil {
            UserDefaultsHandler.promptForUserNickname(self)
        }
        
        
        
        //Force a refresh
        fetchAllLobbies()
//        refresh.beginRefreshing()
//        lobbyTableView.setContentOffset(CGPoint(x: 0, y: -refresh.frame.size.height), animated: true)
//        refresh.sendActions(for: .valueChanged)
    }

    @IBAction func createLobby(_ sender: Any) {
        performSegue(withIdentifier: "createLobby", sender: self)
    }
    
    func fetchAllLobbies() {
        CloudHandler.shared.fetchAllLobbies { (lobbies, error) in
            if error != nil {
               print("Fetch Error: \(error)")
            } else {
                if let lobbies = lobbies {
                    self.displayLobbies(lobbies)
                }
            }
        }
    }
    
    func displayLobbies(_ lobbies: [Lobby]) {
        self.lobbies = lobbies
        self.lobbyTableView.reloadData()
        self.refresh.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: UITableViewDataSource
extension LobbyViewController: UITableViewDataSource {
    
    func joinLobby(_ lobby: Lobby) {
        if let nickname = UserDefaultsHandler.userNickname() {
            lobby.playerList.append(nickname)
            lobby.playerIDs.append(UserDefaultsHandler.uniqueID())
        }
        
        if let index = lobbies.index(of: lobby) {
            lobbies.remove(at: index)
            self.lobbyTableView.reloadData()
        }
        
        CloudHandler.shared.modifyLobby(lobby) { (record, error) in
            if error != nil {
                print("Join lobby error: \(error)")
            } else {
                self.lobbyTableView.reloadData()
                
                let message = "Game Joined!"
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    alert.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lobbies.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LobbyTableViewCell.reuseIdentifier) as! LobbyTableViewCell
        cell.lobby = lobbies[indexPath.section]
        cell.delegate = self
        
        //Cell style
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 2
        cell.clipsToBounds = true
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return LobbyTableViewCell.expandedCellheight
        }
        return LobbyTableViewCell.cellHeight
    }
}

// MARK: UITableViewDelegate
extension LobbyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths: [IndexPath] = []
        if let previous = previousIndexPath {
            indexPaths.append(previous)
        }
        if let current = selectedIndexPath {
            indexPaths.append(current)
        }
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: .none)
        }
    }
}


