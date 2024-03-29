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
    
    func updateRecord(id: ObjectId, _ item: Record) throws -> Record {
        
        
        do {
            try realm.write {
                realm.create(Record.self, value: ["objectID": id, "title": item.title, "date": item.date, "memo": item.memo as Any, "placeInfo": item.placeInfo] , update: .modified)
            
            }
        } catch {
            throw DataBaseError.updateError
        }
        let result = try searchItemByID(id)
        return result
        
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
    
    // 전달한 달의 데이터 리스트를 반환
    func filterItemByMonth(_ date: Date) -> [Record] {
        let last = Calendar.current.date(byAdding: .month, value: 1, to: date)!
        let result = realm.objects(Record.self).sorted(byKeyPath: "date", ascending: true).filter(
            NSPredicate(format: "date >= %@ AND date < %@", date as NSDate, last as NSDate )

        )

        return Array(result)
    }
    
    func filterItemByMonthOnlyDate(_ date: Date) -> [Date] {
        let last = Calendar.current.date(byAdding: .month, value: 1, to: date)!
        let result = realm.objects(Record.self).sorted(byKeyPath: "date", ascending: true).filter(
            NSPredicate(format: "date >= %@ AND date < %@", date as NSDate, last as NSDate )

        ).map {
            $0.date
        }

        return Array(result)
    }
    
    func filterItemByDay(_ date: Date) -> [Record] {
        let max = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        let result = realm.objects(Record.self).sorted(byKeyPath: "date", ascending: false).filter(
            NSPredicate(format: "date >= %@ AND date < %@", date as NSDate, max as NSDate )
            
        )
        
        return Array(result)
    }

}
