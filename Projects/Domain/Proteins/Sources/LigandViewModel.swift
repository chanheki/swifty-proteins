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
import CoreNetworkInterface
import SharedExtensions

public class LigandViewModel: ObservableObject {
    public var ligand: LigandModel?
    @Published public var ligandData: Data?
    @Published public var errorMessage: String?
    @Published public var proteinScene: SCNScene?
    
    var pdbDataProvider: ProteinsPDBDataProvider?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var elementColors: [String: UIColor] = [
        "H": .white,
        "C": .dark,
        "N": .blue,
        "O": .red,
        "F": .green,
        "Cl": .green,
        "Br": UIColor(red: 0.65, green: 0.16, blue: 0.16, alpha: 1.0), // dark red
        "I": UIColor(red: 0.58, green: 0.0, blue: 0.83, alpha: 1.0), // dark violet
        "He": .cyan,
        "Ne": .cyan,
        "Ar": .cyan,
        "Kr": .cyan,
        "Xe": .cyan,
        "P": .orange,
        "S": .yellow,
        "B": UIColor(red: 0.96, green: 0.96, blue: 0.86, alpha: 1.0), // beige
        "Li": UIColor(red: 0.93, green: 0.51, blue: 0.93, alpha: 1.0), // violet
        "Na": UIColor(red: 0.93, green: 0.51, blue: 0.93, alpha: 1.0), // violet
        "K": UIColor(red: 0.93, green: 0.51, blue: 0.93, alpha: 1.0), // violet
        "Rb": UIColor(red: 0.93, green: 0.51, blue: 0.93, alpha: 1.0), // violet
        "Cs": UIColor(red: 0.93, green: 0.51, blue: 0.93, alpha: 1.0), // violet
        "Fr": UIColor(red: 0.93, green: 0.51, blue: 0.93, alpha: 1.0), // violet
        "Be": UIColor(red: 0.0, green: 0.39, blue: 0.0, alpha: 1.0), // dark green
        "Mg": UIColor(red: 0.0, green: 0.39, blue: 0.0, alpha: 1.0), // dark green
        "Ca": UIColor(red: 0.0, green: 0.39, blue: 0.0, alpha: 1.0), // dark green
        "Sr": UIColor(red: 0.0, green: 0.39, blue: 0.0, alpha: 1.0), // dark green
        "Ba": UIColor(red: 0.0, green: 0.39, blue: 0.0, alpha: 1.0), // dark green
        "Ra": UIColor(red: 0.0, green: 0.39, blue: 0.0, alpha: 1.0), // dark green
        "Ti": .gray,
        "Fe": UIColor(red: 0.79, green: 0.33, blue: 0.0, alpha: 1.0), // dark orange
        "Other": .systemPink
    ]
    
    private let elementRadii: [String: CGFloat] = [
        "H": 1.2,
        "C": 1.7,
        "N": 1.55,
        "O": 1.52,
        "F": 1.47,
        "Cl": 1.75,
        "Br": 1.85,
        "I": 1.98,
        "He": 1.4,
        "Ne": 1.54,
        "Ar": 1.88,
        "Kr": 2.02,
        "Xe": 2.16,
        "P": 1.8,
        "S": 1.8,
        "B": 1.92,
        "Li": 1.82,
        "Na": 2.27,
        "K": 2.75,
        "Rb": 3.03,
        "Cs": 3.43,
        "Fr": 3.90,
        "Be": 1.53,
        "Mg": 1.73,
        "Ca": 1.94,
        "Sr": 2.15,
        "Ba": 2.17,
        "Ra": 2.21,
        "Ti": 2.00,
        "Fe": 1.56,
        "Other": 1.5
    ]
    
    public var ligandInfo: String {
        guard let data = ligandData else { return "No data available" }
        return "Ligand data: \(data.count) bytes"
    }
    
    public var elements: [String] {
        return Array(elementColors.keys).sorted()
    }
    
    public var usedElements: [String] {
        guard let ligandData = ligandData else { return [] }
        
        let pdbDataString = String(data: ligandData, encoding: .utf8) ?? ""
        let lines = pdbDataString.split(separator: "\n")
        
        var elements = Set<String>()
        
        for line in lines {
            let components = line.split(separator: " ", omittingEmptySubsequences: true)
            if components.count > 11 && components[0] == "ATOM" {
                let element = String(components[11])
                if elementColors.keys.contains(element) {
                    elements.insert(element)
                }
            }
        }
        
        return Array(elements).sorted()
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
        setupCamera(for: scene)
        self.proteinScene = scene
        self.proteinScene?.background.contents = UIColor.dark
    }
    
    private func setupCamera(for scene: SCNScene) {
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 20)
        cameraNode.name = "camera"
        scene.rootNode.addChildNode(cameraNode)
        
        // 카메라가 원점을 바라보도록 설정
        let targetNode = SCNNode()
        targetNode.position = SCNVector3(0, 0, 0)
        targetNode.name = "target"
        scene.rootNode.addChildNode(targetNode)
        
        let constraint = SCNLookAtConstraint(target: targetNode)
        cameraNode.constraints = [constraint]
        
        // 카메라 회전 애니메이션 추가
        let rotateAction = SCNAction.rotateAround(targetNode.position, byAngle: CGFloat(2 * Float.pi), duration: 20)
        let repeatAction = SCNAction.repeatForever(rotateAction)
        cameraNode.runAction(repeatAction, forKey: "rotateAction")
        
        // 주광 추가 및 카메라 노드의 자식 노드로 설정
        let mainLight = SCNLight()
        mainLight.type = .omni
        mainLight.color = UIColor.white
        let mainLightNode = SCNNode()
        mainLightNode.light = mainLight
        mainLightNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraNode.addChildNode(mainLightNode)
        
        // 보조광 추가
        let fillLight = SCNLight()
        fillLight.type = .omni
        fillLight.color = UIColor(white: 0.5, alpha: 0.8)
        let fillLightNode = SCNNode()
        fillLightNode.light = fillLight
        fillLightNode.position = SCNVector3(x: -10, y: 5, z: 10)
        scene.rootNode.addChildNode(fillLightNode)
        
        // 후광 추가
        let backLight = SCNLight()
        backLight.type = .omni
        backLight.color = UIColor(white: 0.3, alpha: 0.5)
        let backLightNode = SCNNode()
        backLightNode.light = backLight
        backLightNode.position = SCNVector3(x: 10, y: 10, z: -10)
        scene.rootNode.addChildNode(backLightNode)
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
        sphere.firstMaterial?.diffuse.contents = elementColors[element] ?? elementColors["Other"]
        node.geometry = sphere
        node.position = position
        node.name = element
        return node
    }
    
    
    private func getAtomicRadius(for element: String) -> CGFloat {
        return elementRadii[element] ?? elementRadii["Other"]!
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
        let node = SCNNode(geometry: geometry)
        node.name = "stick"
        
        return node
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
            if childNode.geometry is SCNSphere {
                let element = getElement(from: childNode)
                let newRadius = isSpaceFilling ? getAtomicRadius(for: element) : 0.2
                let action = SCNAction.scale(to: CGFloat(newRadius / 0.2), duration: 0.5)
                childNode.runAction(action)
            }
            animateToModel(childNode, isSpaceFilling: isSpaceFilling)
        }
    }
    
    private func getElement(from node: SCNNode) -> String {
        return node.name ?? "Other"
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
    
    public func countForElement(_ element: String) -> Int {
        guard let ligandData = ligandData else { return 0 }
        
        let pdbDataString = String(data: ligandData, encoding: .utf8) ?? ""
        let lines = pdbDataString.split(separator: "\n")
        
        var count = 0
        
        for line in lines {
            let components = line.split(separator: " ", omittingEmptySubsequences: true)
            if components.count > 11 && components[0] == "ATOM" {
                let elementSymbol = String(components[11])
                if elementSymbol == element {
                    count += 1
                }
            }
        }
        
        return count
    }
}
