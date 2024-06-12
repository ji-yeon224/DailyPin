//
//  PlaceRepository.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/03.
//

import Foundation
import RealmSwift

final class PlaceRepository {
  
    
    private let realm = try! Realm()
    
    func fetch() -> [PlaceItem] {
        let data = realm.objects(Place.self)
        return Array(data.reversed()).map { $0.toDomain() }
    }
    
    func createItem(_ item: Place) throws {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            throw DataBaseError.createError
        }
    }
    
    func searchItemByID(_ id: String) throws -> Place {
        guard let data = realm.object(ofType: Place.self, forPrimaryKey: id) else {
            throw DataBaseError.searchError
        }
        return data
    }
    
    func isExistPlace(id: String) -> Bool {
        do {
            let _ = try searchItemByID(id)
        } catch {
            return false
        }
        return true
    }
    
    func updateRecordList(record: Record, place: Place) throws {
        do {
            try realm.write {
                place.recordList.append(record)
            }
        } catch {
            throw DataBaseError.updateError
        }
    }
    

    func getRecordList(id: String) throws -> [Record] {
        
        let place: Place
        do {
            place = try searchItemByID(id)
        } catch {
            throw DataBaseError.searchError
        }
        
        return Array(place.recordList.sorted(byKeyPath: "date", ascending: false))
        
    }
    
    func getRecordListCount(id: String) -> Int {
        
        do {
            let count = try getRecordList(id: id).count
            return count
        } catch {
            return 0
        }
    }
    
    func getFileLocation() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func deleteItem(_ item: Place) throws {
        do {
            try realm.write {
                realm.delete(item.recordList)
                realm.delete(item)
            }
        } catch {
            throw DataBaseError.deleteError
        }
    }
    
}
