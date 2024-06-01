//
//  NetworkErrorEnum.swift
//  CoreNetworkInterface
//
//  Created by Chan on 6/1/24.
//

public enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case noData
    case decodingFailed(Error)
}
