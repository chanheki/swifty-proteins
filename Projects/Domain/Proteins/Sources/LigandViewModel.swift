//
//  LigandViewModel.swift
//  DomainProteins
//
//  Created by Chan on 5/31/24.
//

import Combine
import Foundation
import SceneKit

import DomainProteinsInterface
import CoreNetwork

public class LigandViewModel: ObservableObject {
    @Published public var ligandData: Data?
    @Published public var errorMessage: String?
    @Published public var proteinScene: SCNScene?
    
    var pdbDataProvider: ProteinsPDBDataProvider?
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    public func fetchLigandData(for ligandID: String) {
        NetworkManager.shared.fetchLigandData(for: ligandID) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.ligandData = data
                    self?.createProteinScene(from: data)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // public for XCTest
    public func createProteinScene(from data: Data) {
        guard let pdbDataString = String(data: data, encoding: .utf8) else {
            self.errorMessage = "Failed to convert data to string"
            return
        }
        
        let (proteinNode, atoms) = parsePDB(pdbData: pdbDataString)
        let bondNodes = createBonds(from: pdbDataString, atoms: atoms)
        
        bondNodes.forEach { proteinNode.addChildNode($0) }
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(proteinNode)
        
        self.proteinScene = scene
    }
    
    private func parsePDB(pdbData: String) -> (SCNNode, [Int: SCNNode]) {
        let node = SCNNode()
        var atoms = [Int: SCNNode]()
        let lines = pdbData.split(separator: "\n")
        
        for line in lines {
            let components = line.split(separator: " ", omittingEmptySubsequences: true)
            if components.count > 6 && components[0] == "ATOM" {
                let index = Int(components[1]) ?? 0
                let x = Float(components[6]) ?? 0.0
                let y = Float(components[7]) ?? 0.0
                let z = Float(components[8]) ?? 0.0
                let element = String(components[11])
                
                let atomNode = createAtomNode(element: element, position: SCNVector3(x, y, z))
                node.addChildNode(atomNode)
                atoms[index] = atomNode
            }
        }
        
        return (node, atoms)
    }
    
    private func createAtomNode(element: String, position: SCNVector3) -> SCNNode {
        let node = SCNNode()
        let sphere = SCNSphere(radius: 0.2)
        
        switch element {
        case "C":
            sphere.firstMaterial?.diffuse.contents = UIColor.green
        case "O":
            sphere.firstMaterial?.diffuse.contents = UIColor.red
        case "N":
            sphere.firstMaterial?.diffuse.contents = UIColor.blue
        case "H":
            sphere.firstMaterial?.diffuse.contents = UIColor.white
        case "F":
            sphere.firstMaterial?.diffuse.contents = UIColor.green
        case "S":
            sphere.firstMaterial?.diffuse.contents = UIColor.orange
        default:
            sphere.firstMaterial?.diffuse.contents = UIColor.gray
        }
        
        node.geometry = sphere
        node.position = position
        return node
    }
    
    private func createBonds(from pdbData: String, atoms: [Int: SCNNode]) -> [SCNNode] {
        var bonds = [SCNNode]()
        let lines = pdbData.split(separator: "\n")
        
        for line in lines {
            let components = line.split(separator: " ", omittingEmptySubsequences: true)
            if components.count > 2 && components[0] == "CONECT" {
                let atomIndex = Int(components[1]) ?? 0
                for i in 2..<components.count {
                    let connectedAtomIndex = Int(components[i]) ?? 0
                    if let atomNode = atoms[atomIndex], let connectedAtomNode = atoms[connectedAtomIndex] {
                        let bondNode = createBondNode(from: atomNode.position, to: connectedAtomNode.position)
                        bonds.append(bondNode)
                    }
                }
            }
        }
        
        return bonds
    }
    
    private func createBondNode(from startPosition: SCNVector3, to endPosition: SCNVector3) -> SCNNode {
        let positions: [SCNVector3] = [startPosition, endPosition]
        let positionData = Data(bytes: positions, count: MemoryLayout<SCNVector3>.size * positions.count)
        
        let vertexSource = SCNGeometrySource(data: positionData,
                                             semantic: .vertex,
                                             vectorCount: positions.count,
                                             usesFloatComponents: true,
                                             componentsPerVector: 3,
                                             bytesPerComponent: MemoryLayout<Float>.size,
                                             dataOffset: 0,
                                             dataStride: MemoryLayout<SCNVector3>.size)
        
        let indices: [UInt16] = [0, 1]
        let indexData = Data(bytes: indices, count: MemoryLayout<UInt16>.size * indices.count)
        
        let element = SCNGeometryElement(data: indexData,
                                         primitiveType: .line,
                                         primitiveCount: indices.count / 2,
                                         bytesPerIndex: MemoryLayout<UInt16>.size)
        
        let geometry = SCNGeometry(sources: [vertexSource], elements: [element])
        geometry.firstMaterial?.diffuse.contents = UIColor.gray
        
        return SCNNode(geometry: geometry)
    }
}
