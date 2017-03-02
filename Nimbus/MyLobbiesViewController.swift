//
//  MyLobbiesViewController.swift
//  Nimbus
//
//  Created by Michael Anderson on 2/21/17.
//  Copyright © 2017 Michael Anderson. All rights reserved.
//

import Foundation
import UIKit

class MyLobbiesViewController: LobbyViewController {
    
    @IBOutlet weak var filterControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func displayLobbies(_ lobbies: [Lobby]) {
        
        var filtered = lobbies.filter { (lobby) -> Bool in
            if lobby.playerIDs.contains(UserDefaultsHandler.uniqueID()) {
                return true
            }
            return false
        }
        
        filtered = filterByCurrentFilter(filtered)
        
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
    
    func filterByCurrentFilter(_ lobbies: [Lobby]) -> [Lobby] {
        let filtered = lobbies.filter { (lobby) -> Bool in
            return filterControl.selectedSegmentIndex == 0 ? isUpcomingGame(lobby) : !isUpcomingGame(lobby)
        }
        
        return filtered
    }
    
    func isUpcomingGame(_ lobby: Lobby) -> Bool {
        if lobby.startTime.addingTimeInterval(6 * 3600) > Date() {
            return true
        }
        return false
    }
    
    @IBAction func gameFilterChanged(_ sender: Any) {
        if let lobbies = CloudHandler.shared.cachedLobbies {
            displayLobbies(lobbies)
        }
    }
    
}
