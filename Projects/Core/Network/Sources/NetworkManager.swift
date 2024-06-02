//
//  ProteinsViewController.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import Alamofire
import Foundation

import CoreNetworkInterface

public final class NetworkManager {
    
    public static let shared = NetworkManager()
    private init() {}
    
    public func fetchLigandData(for ligandID: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let baseURL = "https://files.rcsb.org/ligands"
        let endpoint = "\(baseURL)/\(ligandID.prefix(1))/\(ligandID.prefix(3))/\(ligandID)_ideal.pdb"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        AF.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(.requestFailed(error)))
            }
        }
    }
}
