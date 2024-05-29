//
//  AlertMapViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/16.
//

import UIKit
import MapKit

final class AlertMapViewController : UIViewController{
    private var cood: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.566713, longitude: 126.978428)
    
    init(lat: Double?, lng: Double?) {
        super.init(nibName: nil, bundle: nil)
        if let lat = lat, let lng = lng {
            cood = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 뷰 컨트롤러에 맵킷 뷰를 추가한다.
        let mapKitView = MKMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view = mapKitView
        self.preferredContentSize.height = 200
        
        //표시할 위치
        let pos = CLLocationCoordinate2D(latitude: cood.latitude, longitude: cood.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025)
        
        //3.지도 영역을 정의
        let region = MKCoordinateRegion(center: pos, span: span)
        
        //4.지도 뷰에 표시
        mapKitView.region = region
        mapKitView.regionThatFits(region)
        
        //5.위치를 핀으로 표시
        let point = MKPointAnnotation()
        point.coordinate = pos
        mapKitView.addAnnotation(point)
    }
}
