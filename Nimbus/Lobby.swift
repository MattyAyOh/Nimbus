//
//  Lobby.swift
//  Nimbus
//
//  Created by Michael Anderson on 2/1/17.
//  Copyright © 2017 Michael Anderson. All rights reserved.
//

import UIKit
import CloudKit

enum SkillLevel: Int {
    case None = 0,
        Beginner,
        Intermediate,
        Expert
}

enum GameType: Int {
    case 川麻 = 0,
    普通
}

private var playerListKey = "Players"
private var creatorIDKey =  "Creator"
private var wagerKey =      "WagerKey"
private var smokingKey =    "SmokingKey"
private var playerIDsKey =  "PlayerIDs"
private var startTimeKey =  "StartTime"
private var gameNameKey =   "GameName"
private var gameTypeKey =   "GameType"

class Lobby: NSObject {
    //Properties
    var identifier: CKRecordID?
    var creatorID: String?
    var gameName: String?
    var playerList: [String] = []
    var playerIDs: [String] = []
    var startTime: Date = Date()
    
    //Game Filters
    var gameType: GameType = .川麻
    var wager: Bool = false
    var smoking: Bool = false
    var skillLevel: SkillLevel = .None
    
    override init() {
        let userID = UserDefaultsHandler.uniqueID()
        
        self.creatorID = userID
        self.playerIDs = [UserDefaultsHandler.uniqueID()]
        
        if let userNickname = UserDefaultsHandler.userNickname() {
            self.playerList = [userNickname]
        }
    }
    
    init(record: CKRecord) {
        if let playerList = record.value(forKey: playerListKey) as? [String] {
            self.playerList = playerList
        }
        
        if let playerIDs = record.value(forKey: playerIDsKey) as? [String] {
            self.playerIDs = playerIDs
        }
        
        if let creatorID = record.value(forKey: creatorIDKey) as? String {
            self.creatorID = creatorID
        }
        
        if let wager = record.value(forKey: wagerKey) as? Bool {
            self.wager = wager
        }
        
        if let smoking = record.value(forKey: smokingKey) as? Bool {
            self.smoking = smoking
        }
        
        if let startTime = record.value(forKey: startTimeKey) as? Date {
            self.startTime = startTime
        }
        
        if let gameName = record.value(forKey: gameNameKey) as? String {
            self.gameName = gameName
        }
        
        if let gameTypeValue = record.value(forKey: gameTypeKey) as? Int {
            if let gameType = GameType(rawValue: gameTypeValue) {
                self.gameType = gameType
            }
        }
        
        self.identifier = record.recordID
    }
    
    func record() -> CKRecord? {
        var record: CKRecord
        if let id = identifier {
            record = CKRecord(recordType: lobbyType, recordID: id)
        } else {
            record = CKRecord(recordType: lobbyType)
        }

        record.setValue(playerList, forKey:playerListKey)
        record.setValue(startTime, forKey: startTimeKey)
        record.setValue(creatorID, forKey: creatorIDKey)
        record.setValue(playerIDs, forKey: playerIDsKey)
        record.setValue(wager, forKey: wagerKey)
        record.setValue(gameName, forKey: gameNameKey)
        record.setValue(smoking, forKey: smokingKey)
        record.setValue(gameType.rawValue, forKey: gameTypeKey)
        
        return record
    }
    
    static func ==(first: Lobby, second: Lobby) -> Bool {
        return first.identifier == second.identifier
    }

}
