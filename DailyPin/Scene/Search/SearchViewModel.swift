//
//  SearchViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/29.
//

import Foundation
import RxSwift

final class SearchViewModel {
    
    let searchQuery: Observable<String> = Observable("")
//    var searchResult: Observable<Search> = Observable(Search(places: []))
    var items: [PlaceItem] = []
    let searchResult = PublishSubject<[PlaceItem]>()
    var resultError: Observable<String?> = Observable(nil)
    let searchError = PublishSubject<String>()
    
    func callPlaceRequest(query: String, langCode: LangCode, location: (Double, Double)) {
        Task {
            do {
                let item = try await GoogleNetwork.shared.requestData(api: .place(query: query, langCode: langCode, location: location), resultType: SearchResDto.self)
                guard let item = item as? PlaceItemList else { return }
                items = item.item
                searchResult.onNext(items)
            } catch {
                items.removeAll()
                searchResult.onNext(items)
                searchError.onNext(error.localizedDescription)
            }
            
            
        }
       
        
//        GoogleNetwork.shared.requestPlace(api: .place(query: query, langCode: langCode, location: location)) { response in
//            
//            switch response {
//            case .success(let success):
//                if success.places.count == 0 {
//                    print("결과 없음")
//                }
//                
//                self.searchResult.value = success
//            case .failure(let failure):
//                self.resultError.value = failure.localizedDescription
//            }
//        }
        
    }
    
    func removeSearchResult() {
        searchResult.onNext([])
    }
    
}
