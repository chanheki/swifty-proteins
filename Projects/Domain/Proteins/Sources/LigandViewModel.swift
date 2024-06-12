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
import SharedExtensions

public class LigandViewModel: ObservableObject {
    public var ligand: LigandModel?
    @Published public var ligandData: Data?
    @Published public var errorMessage: String?
    @Published public var proteinScene: SCNScene?
    
    var pdbDataProvider: ProteinsPDBDataProvider?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var elementColors: [String: UIColor] = [
        "C": .green,
        "O": .red,
        "N": .blue,
        "H": .white,
        "F": .green,
        "S": .orange,
        "Other": .gray
    ]
    
    public var ligandInfo: String {
        guard let data = ligandData else { return "No data available" }
        return "Ligand data: \(data.count) bytes"
    }
    
    // 원소 목록을 반환하는 프로퍼티
    public var elements: [String] {
        return Array(elementColors.keys)
    }
    
    public init() {}
    
    public func fetchLigandData(for ligandID: String) {
        NetworkManager.shared.fetchLigandData(for: ligandID) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.ligandData = data
                    self?.createBallStickProteinsScene(from: data)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    public func createBallStickProteinsScene(from data: Data) {
        createProteinsScene(from: data, modelType: .ballStick)
    }
    
    public func createSpaceFillingProteinsScene(from data: Data) {
        createProteinsScene(from: data, modelType: .spaceFilling)
    }
    
    private func createProteinsScene(from data: Data, modelType: ProteinsModelType) {
        guard let pdbDataString = String(data: data, encoding: .utf8) else {
            self.errorMessage = "Failed to convert data to string"
            return
        }
        
        let proteinNode = SCNNode()
        let lines = pdbDataString.split(separator: "\n")
        
        var atoms = [Int: SCNNode]()
        
        for line in lines {
            let components = line.split(separator: " ", omittingEmptySubsequences: true)
            if components.count > 6 && components[0] == "ATOM" {
                let index = Int(components[1]) ?? 0
                let x = Float(components[6]) ?? 0.0
                let y = Float(components[7]) ?? 0.0
                let z = Float(components[8]) ?? 0.0
                let element = String(components[11])
                
                let atomNode: SCNNode
                
                atomNode = createNode(element: element, position: SCNVector3(x, y, z), modelType: modelType)
                
                proteinNode.addChildNode(atomNode)
                atoms[index] = atomNode
            }
        }
        
        if modelType == .ballStick {
            let bondNodes = createBonds(from: pdbDataString, atoms: atoms)
            bondNodes.forEach { proteinNode.addChildNode($0) }
        }
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(proteinNode)
        self.proteinScene = scene
        self.proteinScene?.background.contents = UIColor.backgroundColor
    }
    
    private func createNode(element: String, position: SCNVector3, modelType: ProteinsModelType) -> SCNNode {
        let node = SCNNode()
        let sphere: SCNSphere
        switch modelType {
        case .ballStick:
            sphere = SCNSphere(radius: 0.2)
        case .spaceFilling:
            let radius = getAtomicRadius(for: element)
            sphere = SCNSphere(radius: radius)
            
        }
        sphere.firstMaterial?.diffuse.contents = elements.contains(element) ? elementColors[element] : elementColors["Other"]
        node.geometry = sphere
        node.position = position
        return node
    }
    
    
    private func getAtomicRadius(for element: String) -> CGFloat {
        switch element {
        case "C": return 1.7
        case "O": return 1.52
        case "N": return 1.55
        case "H": return 1.2
        case "F": return 1.47
        case "S": return 1.8
        default: return 1.5
        }
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
        geometry.firstMaterial?.lightingModel = .constant
        
        return SCNNode(geometry: geometry)
    }
    
    public func animateToSpaceFillingModel() {
        guard let proteinScene = proteinScene else { return }
        animateToModel(proteinScene.rootNode, isSpaceFilling: true)
    }
    
    public func animateToBallStickModel() {
        guard let proteinScene = proteinScene else { return }
        animateToModel(proteinScene.rootNode, isSpaceFilling: false)
    }
    
    private func animateToModel(_ node: SCNNode, isSpaceFilling: Bool) {
        for childNode in node.childNodes {
            if let geometry = childNode.geometry as? SCNSphere {
                let element = getElement(from: geometry.firstMaterial?.diffuse.contents as? UIColor)
                let newRadius = isSpaceFilling ? getAtomicRadius(for: element) : 0.2
                let action = SCNAction.scale(to: CGFloat(newRadius / 0.2), duration: 0.5)
                childNode.runAction(action)
            }
            animateToModel(childNode, isSpaceFilling: isSpaceFilling)
        }
    }
    
    private func getElement(from color: UIColor?) -> String {
        switch color {
        case UIColor.green: return "C"
        case UIColor.red: return "O"
        case UIColor.blue: return "N"
        case UIColor.white: return "H"
        case UIColor.orange: return "S"
        default: return ""
        }
    }
    
    // 각 원소의 색상 변경 메서드
    public func updateColor(_ color: UIColor, for element: String) {
        elementColors[element] = color
    }
    
    // 원소의 현재 색상을 반환하는 메서드
    public func color(for element: String) -> UIColor {
        return elementColors[element] ?? UIColor.gray
    }
    
    // SCNScene의 배경색 변경 메서드
    public func updateBackgroundColor(_ color: UIColor) {
        proteinScene?.background.contents = color
    }
    
}
