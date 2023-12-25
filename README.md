
<img src="https://github.com/ji-yeon224/DailyPin/assets/69784492/b0901f18-f381-45a2-ba90-fdb579c7bc21.png"  width="150" height="150"/>

# DailyPin - 장소 일기 



![](https://github.com/ji-yeon224/DailyPin/assets/69784492/371edf62-1854-4f81-a184-c61ff2ee8497)

[🔗 앱스토어 바로가기](https://apps.apple.com/kr/app/dailypin-%EC%9E%A5%EC%86%8C%EC%9D%BC%EA%B8%B0/id6470025950)


## 프로젝트 
- 개인 프로젝트
- 2023.09.25 ~ 2323.10.25(4주)
- 최소 지원 버전 iOS 15.0

## 핵심 기능
- 원하는 장소를 검색하여 지도에 위치를 보여주고 기록을 등록할 수 있습니다.
- 원하는 위치를 지도에서 찾아 길게 탭하여 해당 위치에 기록을 등록할 수 있습니다.
- 사용자가 등록한 위치 리스트를 볼 수 있고, 해당 위치에 등록되 기록을 볼 수 있습니다. 
- 달력을 통해 날짜 별 기록을 볼 수 있습니다.


## 기술스택
- 'MVVM'
- 'RxSwift', 'RxGesture'
- 'UIKit', 'MapKit'
- 'Alamofire', 'Codable'
- 'Realm'
- 'SnapKit', 'Autolayout'
- 'DiffableDataSource', 'CompositionalLayout'
- 'Firebase'
	- 'Google Crashlythics'
	- 'Push Notification'
- 'FSCalendar', 'FloatingPanel', 'Toast'
- 'Google Place API'

## 프로젝트 목표
- DiffableDataSource와 CompositionalLayout을 이용하여 CollectionView 구현
- API 통신 시 Alamofire와 Router 패턴을 적용하여 코드의 가독성을 높이고, 재사용성을 높임
- MVVM 패턴을 통해 비즈니스 로직을 분리하여 ViewController의 역할을 줄임
- UI 구현 시 비슷한 구조의 View들을 모듈화 하여 재사용성을 높임


## 트러블슈팅

### Compositional Layout 셀 동적 높이

- 내부 컨텐츠의 높이에 따라 동적으로 높이를 조절하도록 estimated를 사용하였는데, estimated로 정확한 높이 계산이 되지 않아 잘 적용이 안되었다.
- **View의 Drawing Cycle**을 고려하여 데이터가 셀에 삽입된 후 `layoutIfNeeded()`를 호출하여 레이아웃 업데이트를 요청하여 해결하였다.

```swift
private func configureDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<InfoCollectionViewCell, Record> { cell, indexPath, itemIdentifier in
        cell.titleLabel.text = itemIdentifier.title
        cell.address.text = itemIdentifier.placeInfo[0].address
        cell.dateLabel.text = DateFormatter.convertDate(date: itemIdentifier.date)
        cell.layoutIfNeeded() // 레이아웃 업데이트 요청
        
    }
    
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        return cell
    })
}
```

### MVVM 패턴 적용 시 에러 핸들링

- MVVM 패턴을 적용과 Repository 패턴을 이용하여 Realm에 CRUD 작업을 수행하면서 하나의 기능이 여러 파일을 거쳐 ViewController에 전달이 되는 구조가 되었다. 로직을 분리하기 위해 여러 단계를 거쳤지만 에러 핸들링 작업을 계속해서 수행해야 했기 때문에 같은 do-catch문을 여러 번 작성하는 비효율 문제가 발생하였다.
- Observable 타입을 통해 에러 발생 시 값을 errorDescription 값을 변경하였고 ViewController에서 bind하여 에러 메세지를 Alert를 통해 사용자에게 보여주었다.

```swift
// RecordViewModel.swift

var errorDescription: Observable<String?> = Observable(nil)

func savePlace(_ location: PlaceElement?) -> Place? {
    guard let data = location else {
        errorDescription.value = InvalidError.noExistData.errorDescription
        return nil
    }
    
    let place = Place(placeId: data.id, address: data.formattedAddress, placeName: data.displayName.placeName, latitude: data.location.latitude, longitude: data.location.longitude)
    
    do {
        try placeRepository.createItem(place)
        NotificationCenter.default.post(name: .databaseChange, object: nil, userInfo: ["changeType": "save"])
        return place
    } catch {
        errorDescription.value = DataBaseError.createError.errorDescription
        return nil
    }
    
}
```

```swift
// RecordViewController.swift

private func bindData() {
    viewModel.errorDescription.bind { data in
        if let message = data {
            self.showOKAlert(title: "", message: message) { }
        }
    }
}
```

### 그림자 렌더링 이슈

- view에 그림자를 넣었을 때 디버그 창에서 그림자 렌더링에 많은 비용이 들기 때문에 `shadowPath`를 변경하라는 내용의 경고가 나타났다.
- `UIBezierPath`로 그림자를 view의 크기에 맞게 생성 후 `layoutSubView()`내에서 shadowPath 값으로 지정하여 해결하였다.

![Pasted image 20231111142454](https://github.com/ji-yeon224/DailyPin/assets/69784492/b518764a-f8a0-45b7-a995-27a4ee5aa875)


```swift
private func shadow() {
    backView.layer.cornerRadius = backView.frame.size.width / 2
    backView.layer.shadowColor = UIColor.black.cgColor
    backView.layer.shadowOpacity = 0.4
    backView.layer.shadowOffset = CGSize(width: 0, height: 0)
    backView.layer.shadowRadius = 1
    backView.layer.shadowPath = UIBezierPath(arcCenter: CGPoint(x: backView.bounds.width/2, y: backView.bounds.height/2), radius: backView.bounds.width / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
}
```

### Content Type

- Geocoding API 연동 시 Router 패턴을 적용하여 구현하는 중 http load failed 오류가 발생하였다.
- HTTPHeaders에 Content-Type에 대한 설정을 하지 않아 파라미터 값이 정상적으로 전송되지 않았기 때문에 `application/json` 을 header 값에 추가하여 해결하였다.

![Pasted image 20231111142522](https://github.com/ji-yeon224/DailyPin/assets/69784492/c7153a90-5cfb-4dd6-85ed-e4d3468decc6)



## ✍🏻  회고
[🔗 회고](https://iwntberich.tistory.com/84)

- 첫 앱을 출시를 하기 위해 개발하면서 생각보다 고려해야 할 요소가 굉장히 많다는 것을 새삼 깨달았다. 생각보다 고려해야 할 예외 사항들이 많았다. 다양한 예외처리를 구현하고, 화면 전환 시 값 전달과 업데이트 등 깊게 생각해야 할 요소들이 많았다.
- 기획 단계에서 내가 매우 부족했음을 깨달았다. UI 구성도 잘 떠오르지 않아서 대략적인 스토리보드만 그렸더니 계속해서 수정하는 일이 발생했고, 필요한 기능이지만 기획 단계에서 놓쳐버린 기능들도 많았다.
- 메모리 누수에 관련하여 잘 대응을 하지 못한 것 같다. 클로저 구문을 많이 사용하기 때문에 많은 메모리 누수가 있을 것 같은데 해당 부분에서도 더 공부하여 업데이트를 해야겠다는 생각을 하게 되었다. 

## 🗓️ 개발일정
[🔗 개발 일지](https://lowly-yacht-147.notion.site/92e7ac0ff4f84b81b7533c3a46932312?v=8231cce21d104b4cb1d5a3a0b155de2b&pvs=4)
