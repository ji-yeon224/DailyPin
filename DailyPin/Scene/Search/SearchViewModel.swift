//
//  SearchViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/29.
//

import Foundation

final class SearchViewModel {
    
    let searchQuery: Observable<String> = Observable("")
    var searchResult: Observable<Search> = Observable(Search(places: []))
    var resultError: Observable<String?> = Observable(nil)
    
    func callPlaceRequest(query: String, langCode: LangCode, location: (Double, Double)) {
        GoogleNetwork.shared.requestPlace(api: .place(query: query, langCode: langCode, location: location)) { response in
            
            switch response {
            case .success(let success):
                if success.places.count == 0 {
                    print("결과 없음")
                }
                self.searchResult.value = success
            case .failure(let failure):
                self.resultError.value = failure.localizedDescription
            }
        }
        
    }
    
    func removeSearchResult() {
        searchResult.value.places.removeAll()
    }
    
}
