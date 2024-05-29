//
//  PlaceListViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/22.
//

import UIKit
import RxSwift

final class PlaceListViewController: BaseViewController {
    
    let mainView = PlaceListView()
    private let viewModel = PlaceListViewModel()
    private let disposeBag = DisposeBag()
    
    weak var placeListDelegate: PlaceListProtocol?
    
    override func loadView() {
        self.view = mainView
        mainView.collectionViewDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.getAllPlaceData()
    }
    
    deinit {
        print("placelistvc deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func configureUI() {
        super.configureUI()
        
        
    }
    
    private func bindData() {
        
        viewModel.placeList
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, items in
                owner.mainView.setPlaceHolder(items.count > 0)
                owner.updateSnapShot(item: items)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func updateSnapShot(item: [PlaceItem]) {
        var snapShot = NSDiffableDataSourceSnapshot<Int, PlaceItem>()
        snapShot.appendSections([0])
        snapShot.appendItems(item)
        mainView.dataSource.apply(snapShot)
    }
}

extension PlaceListViewController: PlaceCollectionViewProtocol {
    
    func didSelectPlaceItem(item: PlaceItem?) {
        guard let item = item else {
            showToastMessage(message: "toast_errorAlert".localized())
            return
        }
        placeListDelegate?.setPlaceLoaction(data: item)
        dismiss(animated: true)
        
        
    }
}
