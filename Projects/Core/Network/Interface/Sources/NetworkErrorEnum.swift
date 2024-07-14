//
//  NetworkError.swift
//  DomainProteins
//
//  Created by Chan on 7/14/24.
//

import Alamofire
import Foundation

public enum NetworkError: Error {
    case invalidURL
    case requestFailed(AFError)
    case noNetwork
    case notFound
    case unknownError
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다. 다시 시도해주세요."
        case .requestFailed(let error):
            return error.localizedDescription
        case .noNetwork:
            return "네트워크 연결이 원활하지 않습니다. 인터넷 연결을 확인해주세요."
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다. URL을 확인해주세요."
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다. 다시 시도해주세요."
        }
    }
}
