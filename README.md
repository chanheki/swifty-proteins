# swifty-proteins *Apply a modular architecture 

App - Features - Services - Core - Shared(UserInterface) 5개의 레이어를 가집니다.

</br>

# What each layer does (각 기능의 역할)

### App

- 앱의 진입점 및 전체적인 앱 라이프사이클 관리
- 주요 앱 설정 및 초기화 코드

### Feature

- 사용자 인터페이스 및 사용자의 액션을 처리
- 뷰(View) 및 뷰와 관련된 로직

### Domain

- 비즈니스 로직과 애플리케이션의 도메인 모델
- 엔터티, 유스케이스, 리포지토리 인터페이스 등

### Core

- 앱의 비즈니스를 포함하지 않는 순수 기능성 모듈
- 네트워킹, 데이터베이스, 바이오메트릭스 등

### Shared

- 여러 모듈에서 공통적으로 사용되는 코드
- 스타일, 리소스, 확장 기능 등
- 공용 뷰, 디자인 시스템, 리소스 등 UI 요소

</br>

# Implementing each feature (각 기능 구현)

### 인증 부분 - OAuth 사용, 로그인 (Firebase로 구현)

- Core: NetworkingModule (OAuth 네트워크 관련 코드), FirebaseModule (Firebase 인증 관리 코드)
- Domain: AuthDomain (인증 관련 비즈니스 로직 및 인터페이스)
- Feature: AuthFeature (로그인 UI 및 로그인 관련 화면)

### 앱 실행 - 바이오메트리 인증 (TouchID, FaceID 등)

- Core: BiometricModule (바이오메트리 인증 관련 유틸리티 및 네트워크 코드)
- Feature: AuthFeature (바이오메트리 인증 UI 및 화면)

### 에러처리 - API들이나 인증안되거나 한 경우 화면

- Core: ErrorHandlingModule (공통 에러 처리 유틸리티 및 네트워크 에러 핸들링)
- Feature: ErrorFeature (에러 메시지 UI 및 에러 화면)

### 앱 구동

- protein list view: tableView → ligards list
  - Core: NetworkingModule (API 통신 관련 코드)
  - Feature: ProteinFeature (Protein List View - TableView 구현)

- protein model → api로부터 받을 모델을 정의하는곳
  - Domain: ProteinDomain (Protein Model 정의 및 데이터 구조)

- protein viewmodel → api로 받은 모델의 비즈니스로직
  - Domain: ProteinDomain (ViewModel과 관련된 비즈니스 로직)

- protein view: SceneKit → model로 부터 받은 데이터를 보여주는곳
  - Feature: ProteinFeature (Protein View - SceneKit을 사용한 3D 모델 표시)

</br>

### 설계

``` 
App Layer
   |
   v
Feature Layer
   |
   |-- AuthFeature
   |-- ErrorFeature
   |-- ProteinFeature
   |
   v
Domain Layer
   |
   |-- AuthDomain
   |-- ProteinDomain
   v
Core Layer
   |
   |-- NetworkingModule
   |-- FirebaseModule
   |-- BiometricModule
   |-- ErrorHandlingModule
   v
Shared Layer
   |
   |-- ProteinModel
   |-- UtilityModule
   |-- LoggingModule
   |
Shared (UserInterface) Layer
   |
   |-- DesignSystem
   |-- LocalizableManager

```

### 객체지향적 설계

1. 분리된 모듈: 각 레이어와 모듈이 명확히 분리되어야 하며, 특정 기능이 필요한 경우 해당 레이어의 인터페이스를 통해 접근하도록 설계합니다.
2. 재사용성: 공통 코드와 유틸리티는 Shared 및 Core 레이어에 위치시켜 재사용성을 극대화합니다.
3. 의존성 주입: 각 레이어 간의 의존성은 가능한 한 주입 방식을 통해 관리하여 결합도를 낮춥니다.
4. 테스트 가능성: Domain 레이어의 비즈니스 로직, 각 레이어의 로직은 테스트 가능하도록 설계하여 단위 테스트를 용이하게 합니다.
5. UI와 로직 분리: Feature 레이어의 UI와 비즈니스 로직은 명확히 분리하여 코드의 가독성과 유지보수성을 높입니다.
