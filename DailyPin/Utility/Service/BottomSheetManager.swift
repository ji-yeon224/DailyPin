//
//  BottomSheetManager.swift
//  DailyPin
//
//  Created by 김지연 on 5/27/24.
//

import UIKit
import FloatingPanel

final class BottomSheetManager {
    
    static let shared = BottomSheetManager()
    private init() {  }
    weak var delegate: BottomSheetProtocol?
    weak var viewController: UIViewController?
    private var floatingView: FloatingPanelController?
    private var layout = FloatingPanelCustomLayout()
    private var isPresent: Bool = false
    
    func setFloatingView(viewType: FloatingType, vc: UIViewController?) {
        
        if isPresent {
            dismiss()
        }
        
        floatingView = FloatingPanelController()
        floatingView?.delegate = self
        
        guard let floatingView = floatingView else { return }
        
        floatingView.surfaceView.insetsLayoutMarginsFromSafeArea = true
        viewController = vc
        
        switch viewType {
        case .place:
            let vc = PlaceListViewController()
            vc.placeListDelegate = self
            floatingView.set(contentViewController: vc)
            
        case .info(let data):
            let vc = InfoViewController(placeData: data)
            floatingView.set(contentViewController: vc)
        }
        floatingView.layout = layout
        floatingView.changePanelStyle()
        floatingView.invalidateLayout()
        
        isPresent = true
        viewController?.present(floatingView, animated: true)
        
    }
    
    
    func dismiss() {
        guard let floatingView = floatingView else { return }
        if isPresent {
            floatingView.dismiss(animated: true)
            self.floatingView = nil
            isPresent = false
        }
        
    }
    
}

extension BottomSheetManager: FloatingPanelControllerDelegate {
    
    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {        
        
        if state == FloatingPanelState.tip {
            dismiss()
            delegate?.deSelectAnnotation()
        }
    }
    
    
}
extension BottomSheetManager: PlaceListProtocol {
    
    func setPlaceLoaction(data: PlaceItem) {
        dismiss()
        delegate?.setLocation(data: data)
        
    }
}

