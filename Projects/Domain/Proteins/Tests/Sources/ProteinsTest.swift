//
//  ProteinsUITest.swift
//  DomainProteinsInterface
//
//  Created by Chan on 6/2/24.
//

import XCTest
import Combine
import SceneKit

@testable import DomainProteins
@testable import DomainProteinsInterface
@testable import DomainProteinsTesting

final class LigandViewModelTests: XCTestCase {
    private var viewModel: LigandViewModel!
    private var cancellables: Set<AnyCancellable>!
    private var mockPDBDataProvider: MockPDBDataProvider!
    private var sceneView: SCNView!
    
    override func setUpWithError() throws {
        self.mockPDBDataProvider = MockPDBDataProvider()
        self.viewModel = LigandViewModel()
        self.cancellables = []
        
        // MARK: - sceneView를 UITest로 빼서 해야하는 상황. 현재 제대로 저장되지않음.
        self.sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let screenshot = self.captureScreenshot(of: self.sceneView)
        self.saveScreenshot(screenshot, path: "test/swifty-proteins", name: "init.png")
    }
    
    override func tearDownWithError() throws {
        self.mockPDBDataProvider = nil
        self.viewModel = nil
        self.cancellables = nil
        self.sceneView = nil
    }
    
    // MARK: - fetch한 ligand data와 mock data가 같은지 확인하는 테스트
    func testFetchLigandDataAndCompareWithMockData() {
        // Mock PDB 데이터를 제공하는 MockPDBDataProvider
        let mockPDBData = mockPDBDataProvider.getPDBData(name: .pdbMock001).data(using: .utf8)!
        
        // 실제 네트워크 요청을 사용하여 데이터를 가져옴
        let expectation = XCTestExpectation(description: "Fetch ligand data and match with mock data")
        
        var fetchedData: Data?
        
        self.viewModel.$ligandData
            .dropFirst()
            .sink { data in
                fetchedData = data
                XCTAssertNotNil(data, "Ligand data should not be nil")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // 네트워크 요청 수행
        self.viewModel.fetchLigandData(for: "001")
        
        wait(for: [expectation], timeout: 5.0)
        
        // 실제 데이터와 Mock 데이터 비교
        print("Fetched Data Dump")
        dump(fetchedData)
        print("Mock Data Dump")
        dump(mockPDBData)
        
        XCTAssertEqual(fetchedData, mockPDBData, "Fetched data should match the mock data")
    }
    
    // MARK: - Mock 데이터를 통해 Ligand가 Scene에 정확히 로드되는지 확인하는 테스트
    func testMockLigandScene() {
        // Mock PDB 데이터를 제공하는 MockPDBDataProvider
        self.viewModel.pdbDataProvider = mockPDBDataProvider
        
        // 데이터를 받아왔을 때, proteinScene이 제대로 생성되는지 테스트
        let expectation = XCTestExpectation(description: "Fetch ligand data and create protein scene")
        
        self.viewModel.$proteinScene
            .dropFirst()
            .sink { [weak self] scene in
                guard let self = self else { return }
                self.sceneView.scene = scene
                self.sceneView.isPlaying = true // Ensure the scene view is actively rendering
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // 실제 네트워크 요청을 사용하지 않고 Mock 데이터를 사용
        let mockData = mockPDBDataProvider.getPDBData(name: .pdbMock001).data(using: .utf8)!
        print("Mock Data: \(mockData)")
        self.viewModel.createBallStickProteinsScene(from: mockData)
        
        wait(for: [expectation], timeout: 1.0)
        
        // 지연 시간을 추가하여 씬 렌더링이 완료된 후 스크린샷을 캡처
        let screenshotExpectation = XCTestExpectation(description: "Capture screenshot after scene renders")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Capture screenshot
            let screenshot = self.captureScreenshot(of: self.sceneView)
            XCTAssertNotNil(screenshot, "Screenshot should not be nil")
            
            // Save the screenshot to a file
            self.saveScreenshot(screenshot, path: "test/swifty-proteins", name: "seceneTest.png")
            screenshotExpectation.fulfill()
        }
        
        wait(for: [screenshotExpectation], timeout: 2.0)
        
    }
    
    // MARK: - Scene 처리 및 기대치 설정
    private func handleScene(_ scene: SCNScene?, expectation: XCTestExpectation) {
        print("Scene received: \(String(describing: scene))")
        XCTAssertNotNil(scene, "Protein scene should not be nil")
        XCTAssertTrue(scene!.rootNode.childNodes.count > 0, "Protein scene should contain nodes")
        self.sceneView.scene = scene
        expectation.fulfill()
    }
    
    
    // MARK: - 스크린샷 캡쳐 및 저장 메서드
    private func captureScreenshot(of view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
    }
    
    private func saveScreenshot(_ screenshot: UIImage?, path: String, name: String) {
        guard let screenshot = screenshot else { return }
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let testDirectoryURL = documentsURL.appendingPathComponent(path, isDirectory: true)
        
        do {
            // Ensure the directory exists
            try fileManager.createDirectory(at: testDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            
            // Save the screenshot
            let imagePath = testDirectoryURL.appendingPathComponent(name)
            try screenshot.pngData()?.write(to: imagePath)
            print("Screenshot saved to \(imagePath.path)")
        } catch {
            XCTFail("Failed to save screenshot: \(error)")
        }
    }
    
}
