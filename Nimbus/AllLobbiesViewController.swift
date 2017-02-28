//
//  AllLobbiesViewController.swift
//  Nimbus
//
//  Created by Michael Anderson on 2/21/17.
//  Copyright © 2017 Michael Anderson. All rights reserved.
//

import UIKit

enum LobbySorting: Int {
    case NameA = 0,
    NameZ,
    DateFirst,
    DateLast,
    Spots1,
    Spots3
}


class AllLobbiesViewController: LobbyViewController {
    
    var currentSort: LobbySorting = .DateFirst
    var previousSortIndex: Int = 0
    
    @IBOutlet weak var sortControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortControl.selectedSegmentIndex = currentSort.rawValue / 2
    }
    
    override func displayLobbies(_ lobbies: [Lobby]) {
        guard let nickname = UserDefaultsHandler.userNickname() else {
            return
        }
        
        var filtered = lobbies.filter { (lobby) -> Bool in
            if !lobby.playerList.contains(nickname) && lobby.startTime > Date() {
                return true
            }
            return false
        }
        
        filtered = filtered.sorted { (first, second) -> Bool in
            if sortByCurrentSort(first, second) {
                return true
            }
            return false
        }
        
        self.lobbies = filtered
        self.lobbyTableView.reloadData()
        self.refresh.endRefreshing()
    }
    
    func sortByCurrentSort(_ first: Lobby, _ second: Lobby) -> Bool {
        var sorted = false
        
        switch currentSort {
        case .DateFirst:
            sorted = second.startTime > first.startTime
            break
        case .DateLast:
            sorted = first.startTime > second.startTime
            break
        case .NameA:
            if let firstGame = first.gameName,
                let secondGame = second.gameName {
                sorted = firstGame > secondGame
            }
            break
        case .NameZ:
            if let firstGame = first.gameName,
                let secondGame = second.gameName {
                sorted = secondGame > firstGame
            }
            break
        case .Spots1:
            sorted = second.playerList.count > first.playerList.count
            break
        case .Spots3:
            sorted = first.playerList.count > second.playerList.count
            break
        }
        
        return sorted
    }
    
    @IBAction func sortControlChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        if index == previousSortIndex {
            if index == 0 {
                currentSort = .NameA
            } else if index == 1 {
                currentSort = .DateFirst
            } else if index == 2 {
                currentSort = .Spots1
            }
        }
        else {
            if index == 0 {
                currentSort = .NameZ
            } else if index == 1 {
                currentSort = .DateLast
            } else if index == 2 {
                currentSort = .Spots3
            }
        }
        
        previousSortIndex = index
        
        if let lobbies = CloudHandler.shared.cachedLobbies {
            displayLobbies(lobbies)
        } else {
            fetchAllLobbies()
        }
        
    }
    
}
