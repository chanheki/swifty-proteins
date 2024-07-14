//
//  NetworkManager.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import Alamofire
import Foundation

import CoreNetworkInterface

public final class NetworkManager {
    
    public static let shared = NetworkManager()
    
    private let session: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 15
        self.session = Session(configuration: configuration)
    }
    
    public func fetchLigandData(for ligandID: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            completion(.failure(.invalidURL))
            return
        }

        let endpoint = "\(baseURL)/\(ligandID.prefix(1))/\(ligandID.prefix(3))/\(ligandID)_ideal.pdb"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        session.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 404:
                        completion(.failure(.notFound))
                    case 503:
                        completion(.failure(.noNetwork))
                    default:
                        completion(.failure(.requestFailed(error)))
                    }
                } else if let afError = error.asAFError, afError.isSessionTaskError, let underlyingError = afError.underlyingError as NSError?, underlyingError.domain == NSURLErrorDomain {
                    switch underlyingError.code {
                    case NSURLErrorNotConnectedToInternet:
                        completion(.failure(.noNetwork))
                    default:
                        completion(.failure(.requestFailed(error)))
                    }
                } else {
                    completion(.failure(.unknownError))
                }
            }
        }
    }
}
