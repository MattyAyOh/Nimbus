//
//  LobbyTableViewCell.swift
//  Nimbus
//
//  Created by Michael Anderson on 2/14/17.
//  Copyright © 2017 Michael Anderson. All rights reserved.
//

import UIKit

class LobbyTableViewCell: UITableViewCell {

    static let cellHeight: CGFloat = 88
    static let expandedCellheight: CGFloat = 184
    static let reuseIdentifier = "lobbyTableViewCellReuseId"
    static let nibName = "LobbyTableViewCell"
    
    //Labels
    @IBOutlet weak var lobbyName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var openSlotsLabel: UILabel!
    @IBOutlet weak var currentPlayersLabel: UILabel!
    @IBOutlet weak var wagerLabel: UILabel!
    @IBOutlet weak var smokingLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    //Buttons
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    weak var delegate: LobbyViewController?
    
    var lobby: Lobby? {
        didSet {
            if let lobby = lobby {
                lobbyName.text = lobby.gameName
                dateLabel.text = createDateLabel(lobby)
                openSlotsLabel.text = createOpenSlotsLabel(lobby)
                currentPlayersLabel.text = createPlayerList(lobby)
                typeLabel.text = createTypeLabel(lobby)
                wagerLabel.text = lobby.wager ? "YES" : "NO"
                smokingLabel.text = lobby.smoking ? "YES" : "NO"
                
                joinButton.isHidden = lobby.playerIDs.contains(UserDefaultsHandler.uniqueID())
                leaveButton.isHidden = !lobby.playerIDs.contains(UserDefaultsHandler.uniqueID())
                deleteButton.isHidden = lobby.creatorID != UserDefaultsHandler.uniqueID()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createOpenSlotsLabel(_ lobby: Lobby) -> String {
        return "\(lobby.playerList.count) / 4"
    }
    
    func createPlayerList(_ lobby: Lobby) -> String {
        var string = ""
        
        for playerName in lobby.playerList {
            string.append(playerName)

            if playerName != lobby.playerList.last {
                string.append("\n")
            }
        }
        
        return string
    }
    
    func createDateLabel(_ lobby: Lobby) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
        return dateFormatter.string(from: lobby.startTime)
    }
    
    func createTypeLabel(_ lobby: Lobby) -> String {
        var type: String
        
        switch lobby.gameType {
        case .川麻:
            type = "川麻"
            break;
        case .普通:
            type = "普通"
            break;
        }
        
        return type
    }
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        if let delegate = self.delegate, let lobby = lobby {
            delegate.joinLobby(lobby)
            delegate.selectedIndexPath = nil
        }
    }
    
    @IBAction func leaveButtonPressed(_ sender: Any) {
        if let delegate = self.delegate, let lobby = lobby {
            delegate.leaveLobby(lobby)
            delegate.selectedIndexPath = nil
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if let delegate = self.delegate, let lobby = lobby {
            delegate.deleteLobby(lobby)
            delegate.selectedIndexPath = nil
        }
    }
}
