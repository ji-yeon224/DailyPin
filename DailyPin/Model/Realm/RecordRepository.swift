//
//  RecordRepository.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/07.
//

import Foundation
import RealmSwift

final class RecordRepository {
    
    private let realm = try! Realm()
    
    func fetch() -> Results<Record> {
        let data = realm.objects(Record.self)
        return data
    }
    
    func createItem(_ item: Record) throws {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            throw DataBaseError.createError
        }
    }
    
    func deleteItem(_ item: Record) throws {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            throw DataBaseError.deleteError
        }
    }
    
    func updateRecord(id: ObjectId, _ item: Record) throws {
        
        
        do {
            try realm.write {
                print(item)
                realm.create(Record.self, value: ["objectID": id, "title": item.title, "date": item.date, "memo": item.memo as Any, "placeInfo": item.placeInfo] , update: .modified)
                
            }
        } catch {
            throw DataBaseError.updateError
        }
        
    }
    
    func searchItemByID(_ id: ObjectId) throws -> Record {
        guard let data = realm.object(ofType: Record.self, forPrimaryKey: id) else {
            throw DataBaseError.searchError
        }
        return data
    }
    
    func getFileLocation() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func findPlace(_ item: Record) throws -> Place {
        let data: Record
        do {
            data = try searchItemByID(item.objectID)
        } catch {
            throw DataBaseError.searchError
        }
        
        //print(data.placeInfo.first)
        guard let place = data.placeInfo.first else {
            throw InvalidError.noExistData
        }
        return place
        
    }
}
