//
//  LobbyHandler.swift
//  Nimbus
//
//  Created by Michael Anderson on 1/31/17.
//  Copyright © 2017 Michael Anderson. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

public let lobbyType = "Lobby"

class CloudHandler {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    var subscriptionIslocallyCached = false
    
    static let shared: CloudHandler = {
        return CloudHandler()
    }()
    
    func loginToICloud() {
        if (subscriptionIslocallyCached) {return}
        
        let sub = CKDatabaseSubscription(subscriptionID: "shared-changes")
        
        let info = CKNotificationInfo()
        info.shouldSendContentAvailable = true
        
        sub.notificationInfo = info
        
        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [sub], subscriptionIDsToDelete: [])
        operation.modifySubscriptionsCompletionBlock = { savedSubscriptions, deletedSubscriptionIDs, error in
            if error != nil {
                print (error)
            } else {
                self.subscriptionIslocallyCached = true
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        operation.qualityOfService = .utility
        publicDB.add(operation)
        
//        CKContainer.default().fetchUserRecordID { (recordID, error) in
//            if let record = recordID {
//                CKContainer.default().discoverUserIdentity(withUserRecordID: record, completionHandler: { (userID, error) in
//                    if let id = userID {
//                        self.userID = record.recordName
//                        self.userNickname = id.nameComponents?.nickname
//                    } else {
//                        print(error)
//                    }
//                })
//            } else if let error = error as? NSError {
//                print(error)
//            }
//        }
    }
    
    func createLobby(_ lobby: Lobby, completion: @escaping (_ record: CKRecord?, _ error: Error?) -> Void) {
        guard let record = lobby.record() else {
            //
            return
        }

        publicDB.save(record) { (savedRecord, error) in
            DispatchQueue.main.async {
                completion(record, error)
            }
        }
    }
    
    func modifyLobby(_ lobby: Lobby, completion: @escaping (_ record: CKRecord?, _ error: Error?) -> Void) {
        guard let record = lobby.record() else {
            //
            return
        }
        
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        modifyOperation.savePolicy = .allKeys
        modifyOperation.qualityOfService = .userInitiated
        modifyOperation.perRecordCompletionBlock = { record, error in
            completion(record, error)
        }
        
        publicDB.add(modifyOperation)
    }
    
    func deleteLobby(_ lobby: Lobby, completion: @escaping (_ error: Error?) -> Void) {
        guard let record = lobby.record() else {
            return
        }
        
        publicDB.delete(withRecordID: record.recordID) { (recordID, error) in
            print("Deleted record ids \(recordID) with error \(error)")
            if error != nil {
                
            }
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    func fetchAllLobbies(_ completion: @escaping (_ records: [Lobby]?, _ error: Error?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: lobbyType, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            let lobbies = records?.map(Lobby.init)
            DispatchQueue.main.async {
                completion(lobbies, error)
            }
        }
    }
}
