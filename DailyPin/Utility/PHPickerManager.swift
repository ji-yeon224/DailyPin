//
//  PHPickerManager.swift
//  DailyPin
//
//  Created by 김지연 on 3/14/24.
//

import UIKit
import PhotosUI
import RxSwift

final class PHPickerManager {
    
    static let shared = PHPickerManager()
    private init() { }
    private weak var viewController: UIViewController?
    
    
    
    let selectedImage = PublishSubject<[UIImage]>()
    var disposeBag = DisposeBag()
    
    func presentPicker(vc: UIViewController, selectLimit: Int = 1) {
        self.viewController = vc
        self.disposeBag = DisposeBag()
        let filter = PHPickerFilter.images
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = filter
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selection = .ordered
        configuration.selectionLimit = selectLimit
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        viewController?.present(picker, animated: true)
    }
}

extension PHPickerManager: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let group = DispatchGroup()
        var imgList: [UIImage] = []
        guard let viewController else {return}
        if results.isEmpty {
            viewController.dismiss(animated: true)
        } else {
            results.forEach {
                group.enter()
                let item = $0.itemProvider
                item.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        guard let img = image as? UIImage else { return }
                        imgList.append(img)
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
                self.selectedImage.onNext(imgList)
                self.viewController?.dismiss(animated: true)
//                self.selectedImage.onCompleted()
            }

        }
        
    }
}
