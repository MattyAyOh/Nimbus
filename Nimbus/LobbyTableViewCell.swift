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
    static let expandedCellheight: CGFloat = 155
    static let reuseIdentifier = "lobbyTableViewCellReuseId"
    static let nibName = "LobbyTableViewCell"
    
    @IBOutlet weak var lobbyName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var openSlotsLabel: UILabel!
    @IBOutlet weak var currentPlayersLabel: UILabel!
    
    weak var delegate: LobbyViewController?
    
    var lobby: Lobby? {
        didSet {
            if let lobby = lobby {
                lobbyName.text = lobby.gameName
                dateLabel.text = createDateLabelForLobby(lobby)
                openSlotsLabel.text = createOpenSlotsLabelForLobby(lobby)
                currentPlayersLabel.text = createPlayerListForLobby(lobby)
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
    
    func createOpenSlotsLabelForLobby(_ lobby: Lobby) -> String {
        return "\(lobby.playerList.count) / \(lobby.maxPlayerSize)"
    }
    
    func createPlayerListForLobby(_ lobby: Lobby) -> String {
        var string = ""
        
        for playerName in lobby.playerList {
            string.append(playerName)

            if playerName != lobby.playerList.last {
                string.append("\n")
            }
        }
        
        return string
    }
    
    func createDateLabelForLobby(_ lobby: Lobby) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
        return dateFormatter.string(from: lobby.startTime)
    }
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        if let delegate = self.delegate, let lobby = lobby {
            delegate.deleteLobby(lobby)
            delegate.selectedIndexPath = nil
        }
    }
}
