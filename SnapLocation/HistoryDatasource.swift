//
//  HistoryTableDatasource.swift
//  SnapLocation
//
//  Created by Jeff on 12/5/15.
//  Copyright © 2015 Jeff Greenberg. All rights reserved.
//

import Foundation
import RealmSwift

/// history data source - realm database
class HistoryDataSource {
    
    var locations: Results<SnapLocationObject>
    
    var realm: Realm!
    
    init() {
        realm = try! Realm()
        locations = realm.objects(SnapLocationObject)
    }
    
    /// find and return next Id number
    internal func getNextId() -> Int {
        if let maxId: Int = locations.max("id") {
            return maxId + 1
        }
        return (0)
    }
    
    /// get new Id and adds SnapLocationObject to realm history db
    internal func addHistoryWithNextId(object: SnapLocationObject) {
        object.id =  getNextId()
        do {
            try realm.write {
                self.realm.add(object)
            }
        } catch {
            print("HistoryDataSource: addHistoryWithNextId failed")
        }
    }
    
    internal func removeHistoryAtIndex(index: Int) {
        do {
            try realm.write {
                self.realm.delete(self.locations[index])
            }
        } catch {
            print("HistoryDataSource: removeHistoryAtIndex failed")
        }
    }
    
    /// cell count used by table controller to
    /// determine number of location/history cells
    /// - returns: locations count as Int
    internal func count() -> Int {
        return locations.count
    }
    
    /// get & return location as SnapLocationObject based on primary key -- database id
    internal func getHistoryDataByPrimaryKey(id: Int) -> SnapLocationObject? {
        return (realm.objectForPrimaryKey(SnapLocationObject.self, key: id))
    }
    
    /// get and return location as SnapLocationObject based on cell index
    /// - parameter index: as integer, used to sync with cell
    /// - returns: location as SnapLocationObject or nil
    internal func getHistoryDataByIndex(index: Int) -> SnapLocationObject? {
        
        if index >= locations.count {
            return nil
        }
        
        return locations[index]
    }
    
    internal func getAllImagesUUIDArray() -> [String] {
        return locations.map( { $0.imageUUID })
    }
    
    internal func clearAllHistoryData() {
        do {
            try realm.write {
                self.realm.delete(self.locations)
            }
        } catch {
            print("clearAllHistoryData failed")
        }
    }
    
}
