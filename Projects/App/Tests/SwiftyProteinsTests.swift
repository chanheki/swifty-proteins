import Foundation
import XCTest

@testable import SwiftyProteins

final class SwiftyProteinsTests: XCTestCase {
    func test_twoPlusTwo_isFour() {
        XCTAssertEqual(2+2, 4)
    }
    
}

//final class ProteinModelTests: XCTestCase {
//    func testProteinModelParsing() {
//        let json = """
//        {
//            "id": "1",
//            "name": "Hemoglobin",
//            "structure": "Fe2+"
//        }
//        """.data(using: .utf8)!
//        
//        let decoder = JSONDecoder()
//        do {
//            let protein = try decoder.decode(Protein.self, from: json)
//            XCTAssertEqual(protein.id, "1")
//            XCTAssertEqual(protein.name, "Hemoglobin")
//            XCTAssertEqual(protein.structure, "Fe2+")
//        } catch {
//            XCTFail("Decoding failed: \(error)")
//        }
//    }
//}
//
//final class ProteinServiceTests: XCTestCase {
//    var service: ProteinService!
//    var mockNetworkManager: MockNetworkManager!
//    
//    override func setUp() {
//        super.setUp()
//        mockNetworkManager = MockNetworkManager()
//        service = ProteinService(networkManager: mockNetworkManager)
//    }
//    
//    func testFetchProteinSuccess() {
//        let expectedProtein = Protein(id: "1", name: "Hemoglobin", structure: "Fe2+")
//        let mockResponse = try! JSONEncoder().encode(expectedProtein)
//        mockNetworkManager.mockResponse = mockResponse
//        
//        service.fetchProtein { result in
//            switch result {
//            case .success(let protein):
//                XCTAssertEqual(protein, expectedProtein)
//            case .failure(let error):
//                XCTFail("Expected success, got \(error) instead")
//            }
//        }
//    }
//}
//
//final class MockNetworkManager: NetworkManaging {
//    var mockResponse: Data?
//    
//    func fetchProteinData(completion: @escaping (Result<Data, Error>) -> Void) {
//        if let mockResponse = mockResponse {
//            completion(.success(mockResponse))
//        } else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
//        }
//    }
//}
