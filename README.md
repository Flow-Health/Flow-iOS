<div align=center>
  <img src="https://github.com/Flow-Health/Flow-iOS/assets/80248855/7889c10b-828a-4bf2-a0b4-91c8671f330e" width="100%"/>
</div>
<br>
  <a href="https://apps.apple.com/us/app/flow-%EB%A7%A4%EC%9D%BC-%EB%B3%B5%EC%9A%A9%ED%95%9C-%EC%95%BD-%EA%B8%B0%EB%A1%9D%ED%95%98%EA%B8%B0/id6502969163">
    <img src="https://github.com/Flow-Health/Flow-iOS/assets/80248855/f014da27-3591-46bb-9f6c-10d7e665dd71" width="30%"/>
  </a>
<br>

# 프로젝트 소개 
> Flow는 사용자가 복용한 약을 기록하고, 쉽게 확인하며 원하는 약의 상세정보를 빠르게 확인하는 것을 목표로 개발하는 프로젝트 입니다.<br>
식품의약품안전처에서 제공하는 약 정보 API를 사용하여 사용자가 복용하는 약을 지정하고, AppIntent를 사용한 위젯 상호작용으로 복용약을 기록하여 SQlite로 저장하였습니다.

<br>

# 서비스 필요성
- 최근 식습관 변화 등의 원인으로 당뇨병과 같은 만성 질환자 발생률이 증가[[1]](https://www.docdocdoc.co.kr/news/articleView.html?idxno=3012080)하게 되었고, 이로인해 지속적으로 약을 복용해야 하는 사람들이 생겨났습니다.
- 하지만 약을 제때 복용하지 못하거나 언제 약을 복용하였는지 잊어버리는 문제가 발생하고 있습니다.[[2]](https://www.kukinews.com/newsView/kuk201905140330)
- 또, 복용 기록을 위한 앱 서비스들은 앱에 접속 후 기록해야 한다는 번거러움이 있었습니다.
- 이런 문제점을 해결하기 위해 위젯으로 홈 화면에서 간단하게 기록하고, 마지막으로 복약한 시간을 위젯으로 확인할 수 있는 기능을 추가한 서비스인 FLOW를 개발하게 되었습니다.
<br>

# 개발 목표
1. 주기적으로 약 복용 기록을 하는 사용자가 쉽고 간단하게 정보를 기록하고, 조회할 수 있다.
2. 사용자가 복용하는 약의 신뢰성 있는 정보(주의사항, 복용방법 등)를 간단하게 확인할 수 있다.
3. 사용자가 기록한 기록을 날짜별로 분류하여 복용 기록의 흐름을 확인하고 관리할 수 있다.
4. 주기적인 기록으로 사용자가 쉽게 복약 습관을 형성할 수 있다.
<br>

# 사용기술 및 개발도구
### 사용언어
<div>
  <img src="https://img.shields.io/badge/swift-F05138?style=for-the-badge&logo=swift&logoColor=white">
</div>

### 개발 환경
<div>
  <img src="https://img.shields.io/badge/xcode 15.3-147EFB?style=for-the-badge&logo=xcode&logoColor=white">
  <img src="https://img.shields.io/badge/iOS 17-000000?style=for-the-badge&logo=apple&logoColor=white">
</div>

### 개발 도구
<div>
  <img src="https://img.shields.io/badge/figma-6c25be?style=for-the-badge&logo=figma&logoColor=white">
  <img src="https://img.shields.io/badge/postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white">
  <img src="https://img.shields.io/badge/notion-4C4C4C?style=for-the-badge&logo=notion&logoColor=white">
  <img src="https://img.shields.io/badge/tuist-236CFF?style=for-the-badge&logo=tuist&logoColor=white">
</div>

### 라이브러리
- [Moya](https://github.com/Moya/Moya)
- [RxSwift](https://github.com/ReactiveX/RxSwift)
- [RxFlow](https://github.com/RxSwiftCommunity/RxFlow)
- [RxGesture](https://github.com/RxSwiftCommunity/RxGesture.git)
- [SnapKit](https://github.com/SnapKit/SnapKit)
- [Then](https://github.com/devxoul/Then)
- [SQLite](https://github.com/stephencelis/SQLite.swift.git)
<br>

# 아키텍처
<img src="https://github.com/Flow-Health/Flow-iOS/assets/80248855/f51abe68-0a4c-4079-bf48-9e03ffb5a4f3" width="100%">
