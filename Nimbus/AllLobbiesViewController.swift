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


let sortTitles = ["Name ↑", "Name ↓", "Date ↑", "Date ↓", "Open Spots ↑", "Open Spots ↓"]


class AllLobbiesViewController: LobbyViewController {
    
    var currentSort: LobbySorting = .DateFirst
    var previousSortIndex: Int = 0
    var sortPicker: PickerArrayController?
    var moneyFilter: Bool = false
    var smokingFilter: Bool = false
    var gameType1Filter: Bool = false
    var gameType2Filter: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func displayLobbies(_ lobbies: [Lobby]) {
        var filtered = lobbies.filter { (lobby) -> Bool in
            if !lobby.playerIDs.contains(UserDefaultsHandler.uniqueID()) && lobby.startTime > Date() {
                return true
            }
            return false
        }
        
        filtered = filtered.filter({ (lobby) -> Bool in
            return filterByCurrentFilter(lobby)
        })
        
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
    
    func filterByCurrentFilter(_ lobby: Lobby) -> Bool {
        
        if moneyFilter && !lobby.smoking {
            return false
        }
        
        if smokingFilter && !lobby.smoking {
            return false
        }
        
        if gameType1Filter && lobby.gameType != .川麻 {
            return false
        }
        
        if gameType2Filter && lobby.gameType != .普通 {
            return false
        }
        
        return true
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
                sorted = secondGame > firstGame
            }
            break
        case .NameZ:
            if let firstGame = first.gameName,
                let secondGame = second.gameName {
                sorted = firstGame > secondGame
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
    
    @IBAction func nameSort(_ sender: Any) {
        if currentSort == .NameA {
            currentSort = .NameZ
        } else {
            currentSort = .NameA
        }
        refreshLobbies()
    }
    
    
    @IBAction func dateSort(_ sender: Any) {
        if currentSort == .DateFirst {
            currentSort = .DateLast
        } else {
            currentSort = .DateFirst
        }
        refreshLobbies()
    }
    
    @IBAction func openSlotsSort(_ sender: Any) {
        if currentSort == .Spots1 {
            currentSort = .Spots3
        } else {
            currentSort = .Spots1
        }
        refreshLobbies()
    }
    
    @IBAction func moneyFilterPressed(_ sender: Any) {
        moneyFilter = !moneyFilter
        
        refreshLobbies()
    }
    
    @IBAction func smokingFilterPressed(_ sender: Any) {
        smokingFilter = !smokingFilter
        
        refreshLobbies()
    }
    
    @IBAction func type1Pressed(_ sender: Any) {
        gameType1Filter = !gameType1Filter
        
        refreshLobbies()
    }

    @IBAction func type2Pressed(_ sender: Any) {
        gameType2Filter = !gameType2Filter
        
        refreshLobbies()
    }
    
    func refreshLobbies() {
        if let lobbies = CloudHandler.shared.cachedLobbies {
            displayLobbies(lobbies)
        } else {
            fetchAllLobbies()
        }
    }

    
}
