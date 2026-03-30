# Habit Management (To the Deep Green)

## 소개

GitHub 프로필에 보이는 **기여도 그래프(잔디밭)** 처럼, “오늘 한 칸을 채웠다”는 감각이 눈에 보일 때 습관이 오래 유지된다는 아이디어에서 출발한 **iOS 습관 관리 앱**입니다. 커밋이 날마다 색으로 쌓이듯, 사용자가 완료한 날을 달력과 통계로 묶어 **한눈에 패턴을 읽을 수 있게** 만드는 것을 목표로 했습니다.

습관을 추가·수정·삭제하고, 오늘 할 일만 보거나 전체를 보며 체크하며, 완료 이력은 **잔디밭에 가까운 시각적 피드백**으로 돌려주고, 일·주·월 단위 그래프와 달성도 리포트로 **동기를 유지**할 수 있도록 구성했습니다.


## Skills

- SwiftUI  
- The Composable Architecture (TCA)  
- Swift Concurrency (`async` / `await`, `Effect`)  
- MVVM (기존 ViewModel 경로)  
- Realm  

## Environment

- Xcode  
- Swift 5  
- iOS 15.2+  

## Library

| Library | version | Function |
|--------|---------|----------|
| **Realm / RealmSwift** | 10.33.0 (core 12.13.0) | 습관·일별 완료·통계 데이터 로컬 저장, 스키마 마이그레이션 |
| **swift-composable-architecture** | 1.6.0 | 화면별 Reducer, `Effect`로 비동기 저장소 접근 |
| **Firebase iOS SDK** | 9.6.0 | 푸시·분석 등 (연동 구성) |
| **SwiftProtobuf** | 1.36.1 | Firebase 등 SPM 의존 체인 구성요소 |

## 주요 기능

- 습관 추가, 수정, 삭제  
- 습관을 완료한 날을 **달력(캘린더)** 으로 한눈에 확인  
- **오늘 할 일 / 전체 보기**, 완료 숨김 등 목록 필터  
- 습관 **순서 변경** (길게 누른 뒤 드래그, Realm에 순서 저장)  
- 일·주·월 등 완료 습관 **통계·그래프**  
- 습관 달성도에 대한 **리포트·피드백 문구**  

## Learned

- Realm 로컬 DB **CRUD**, `Results` / `NSPredicate` 기반 필터, **`write` 트랜잭션**, **스키마 버전·마이그레이션** 및 단위 테스트로 검증  
- TCA로 **상태·액션·Effect**를 나누고, `@Sendable` **Dependency 클라이언트**로 저장소 접근 경계 두기  
- 홈에서 완료할 때마다 상단 달력이 불필요하게 갱신되며 느려지는 문제를 **구독 범위 축소·갱신·조회 최적화**로 완화  
- 기기별 비율에 맞춘 **스케일링 Modifier**로 레이아웃 일관성 유지  
