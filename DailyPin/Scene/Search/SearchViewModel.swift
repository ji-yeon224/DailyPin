//
//  SearchViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/29.
//

import Foundation

final class SearchViewModel {
    
    let searchQuery: Observable<String> = Observable("")
    let searchResult: Observable<Place> = Observable(Place(places: []))
    
    func callPlaceRequest(query: String, langCode: LangCode) {
        GoogleNetwork.shared.requestPlace(api: .place(query: query, langCode: langCode)) { response in
            switch response {
            case .success(let success):
                self.searchResult.value = success
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
    
}
