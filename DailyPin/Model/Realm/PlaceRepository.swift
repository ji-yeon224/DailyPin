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
    
    func fetch() -> Results<Place> {
        let data = realm.objects(Place.self)
        return data
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
    
//    func isExistPlace(id: String) -> Place? {
//        do {
//            let place = try searchItemByID(id)
//            return place
//        } catch {
//            return nil
//        }
//
//    }
    
    func getFileLocation() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func deleteItem(_ item: Place) throws {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            throw DataBaseError.deleteError
        }
    }
    
}
