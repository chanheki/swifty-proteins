//
//  Ligand.swift
//  DomainProteinsInterface
//
//  Created by Chan on 9/28/26.
//

public struct Ligand: Equatable {
    public let identifier: String
    public let atoms: [Atom]
    public let bonds: [Bond]

    public init(identifier: String, atoms: [Atom], bonds: [Bond]) {
        self.identifier = identifier
        self.atoms = atoms
        self.bonds = bonds
    }
}

public struct Atom: Equatable {
    /// CIF의 atom_id (예: "C1", "O5'")
    public let name: String
    /// 원소 기호 (예: "C", "Cl", "Fe")
    public let element: String
    public let position: SIMD3<Float>

    public init(name: String, element: String, position: SIMD3<Float>) {
        self.name = name
        self.element = element
        self.position = position
    }
}

public struct Bond: Equatable {
    public enum Order: Equatable {
        case single
        case double
        case triple
        case aromatic
        case other
    }

    /// `Ligand.atoms`의 인덱스
    public let atomIndex1: Int
    public let atomIndex2: Int
    public let order: Order

    public init(atomIndex1: Int, atomIndex2: Int, order: Order) {
        self.atomIndex1 = atomIndex1
        self.atomIndex2 = atomIndex2
        self.order = order
    }
}
