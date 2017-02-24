//
//  AllLobbiesViewController.swift
//  Nimbus
//
//  Created by Michael Anderson on 2/21/17.
//  Copyright © 2017 Michael Anderson. All rights reserved.
//

import Foundation


class AllLobbiesViewController: LobbyViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func displayLobbies(_ lobbies: [Lobby]) {
        guard let nickname = UserDefaultsHandler.userNickname() else {
            return
        }
        
        var filtered = lobbies.filter { (lobby) -> Bool in
            if !lobby.playerList.contains(nickname) {
                return true
            }
            return false
        }
        
        filtered = filtered.sorted { (first, second) -> Bool in
            if second.startTime > first.startTime {
                return true
            }
            return false
        }
        
        self.lobbies = filtered
        self.lobbyTableView.reloadData()
        self.refresh.endRefreshing()
    }
    
}
