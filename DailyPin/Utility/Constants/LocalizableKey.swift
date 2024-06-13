//
//  LocalizableKey.swift
//  DailyPin
//
//  Created by 김지연 on 6/12/24.
//

import Foundation

enum LocalizableKey: String {
    case searchPlaceholder
    case myRecord
    case placeHolder_noPlaceList
    case okText
    case cancelText
    case today
    case locationAlertTitle
    case location_denied
    case location_Restricted
    case locationServicesEnabled
    case locationFail
        
    case toast_errorAlert
    case toast_searchInputError
    case toast_titleIsEmpty
    case toast_saveComplete
    case toast_editComplete
    case toase_recordLoadError
    
    case alert_deleteTitle
    case alert_deleteMessage
    case alert_alertEditModeTitle
    case alert_alertEditModeMessage
    case alert_addRecordTitle
    case record_titleLimit
    case createText
    case updateText
    case successDelete
    
    case alert_dateLoadError
    case alert_locationLoadError
    
    case network_emptyResult
    case network_wrongREquest
    case network_invalidServer
    case network_connectErrorTitle
    case network_connectError
    case invalid_invalidInput
    case invalid_emtyQuery
    case invalid_invalidQuery
    case invalid_noExistData
    case error_emptySearchResult
    
    case record_writeRecord
    case record_writeTitle
    
    case saveButton
    case editButton
    case deleteButton
    
    var localized: String {
        return self.rawValue.localized()
    }
}
