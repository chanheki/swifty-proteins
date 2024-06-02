//
//  ProteinsPDBDataProvider.swift
//  FeatureProteinsTesting
//
//  Created by Chan on 5/30/24.
//

public protocol ProteinsPDBDataProvider {
    func getPDBData(name: TestingNameEnum) -> String
}
