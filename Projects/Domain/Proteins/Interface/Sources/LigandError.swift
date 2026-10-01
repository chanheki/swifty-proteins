//
//  LigandError.swift
//  DomainProteinsInterface
//
//  Created by Chan on 9/28/26.
//

import Foundation

public enum LigandError: Error, Equatable {
    case invalidIdentifier
    case noConnection
    case timeout
    case notFound
    case parsingFailed
    case unknown
}

extension LigandError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidIdentifier:
            return "잘못된 리간드 ID입니다."
        case .noConnection:
            return "인터넷에 연결되어 있지 않습니다. 네트워크를 확인해주세요."
        case .timeout:
            return "요청 시간이 초과되었습니다. 다시 시도해주세요."
        case .notFound:
            return "리간드를 찾을 수 없습니다(404). 데이터베이스에 없는 리간드일 수 있습니다."
        case .parsingFailed:
            return "리간드 데이터를 해석하지 못했습니다. 파일이 손상되었을 수 있습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다. 다시 시도해주세요."
        }
    }
}
