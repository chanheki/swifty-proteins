import XCTest

@testable import FeatureProteins
@testable import FeatureProteinsInterface
@testable import FeatureProteinsTesting

final class ProteinsTests: XCTestCase {

    var viewController: ProteinsViewController!
    var mockPDBDataProvider: ProteinsPDBDataProvider!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Mock PDB 데이터 제공자 생성
        mockPDBDataProvider = MockPDBDataProvider()
        
        // ProteinsViewController 생성 및 의존성 주입
        viewController = ProteinsViewController()
        viewController.pdbDataProvider = mockPDBDataProvider
        
        // Ligand 생성
        let ligand = Ligand(identifier: "TestLigand")
        viewController.ligand = ligand
        
        // Load view hierarchy
        viewController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        viewController = nil
        mockPDBDataProvider = nil
        try super.tearDownWithError()
    }

    func testViewControllerTitleIsSet() {
        XCTAssertEqual(viewController.title, "TestLigand")
    }
    
    func testViewControllerLigandIsSet() {
        XCTAssertEqual(viewController.ligand?.identifier, "TestLigand")
    }
    
    func testPDBDataProviderIsSet() {
        XCTAssertNotNil(viewController.pdbDataProvider)
    }
    
    func testPDBDataIsLoaded() {
        // PDB 데이터를 사용하여 SceneKit 노드를 생성했는지 확인
        XCTAssertNotNil(viewController.pdbDataProvider?.getPDBData())
    }

    // 더 많은 테스트 메서드를 추가하여 다양한 시나리오를 테스트할 수 있습니다.
}
