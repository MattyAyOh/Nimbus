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

private var playerListKey = "Players"
private var creatorIDKey = "Creator"
private var playerSizeKey = "PlayerSize"
private var startTimeKey = "StartTime"
private var gameNameKey = "GameName"

class Lobby: NSObject {
    //Properties
    var identifier: CKRecordID?
    var creatorID: String?
    var gameName: String?
    var playerList: [String] = []
    var maxPlayerSize: Int = 0
    var startTime: Date = Date()
    
    //Game Filters
    var forMoney: Bool = false
    var smoking: Bool = false
    var skillLevel: SkillLevel = .None
    
    override init() {
        let userID = UserDefaultsHandler.uniqueID()
        
        self.creatorID = userID
        
        if let userNickname = UserDefaultsHandler.userNickname() {
            self.playerList = [userNickname]
        }
    }
    
    init(record: CKRecord) {
        if let playerList = record.value(forKey: playerListKey) as? [String] {
            self.playerList = playerList
        }
        
        if let creatorID = record.value(forKey: creatorIDKey) as? String {
            self.creatorID = creatorID
        }
        
        if let playerSize = record.value(forKey: playerSizeKey) as? Int {
            self.maxPlayerSize = playerSize
        }
        
        if let startTime = record.value(forKey: startTimeKey) as? Date {
            self.startTime = startTime
        }
        
        if let gameName = record.value(forKey: gameNameKey) as? String {
            self.gameName = gameName
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
        record.setValue(maxPlayerSize, forKey: playerSizeKey)
        record.setValue(gameName, forKey: gameNameKey)
        
        return record
    }
    
    static func ==(first: Lobby, second: Lobby) -> Bool {
        return first.identifier == second.identifier
    }

}
