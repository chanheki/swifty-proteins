//
//  ProteinsViewController.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import UIKit
import SceneKit

import FeatureProteinsInterface
import SharedCommonUI
import SharedModel

public class ProteinsViewController: BaseViewController<ProteinsView> {
    var ligand: Ligand?
    var pdbDataProvider: ProteinsPDBDataProvider?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupProperty()
        setupView()
    }
    
    // MARK: - BaseViewControllerProtocol
    
    func setupNavigationBar() {
        setNavigationBarHidden(true)
    }
    
    public override func setupProperty() {
        view.backgroundColor = .backgroundColor
    }
    
    private func setupView() {
        guard let ligand = ligand, let pdbDataProvider = pdbDataProvider else { return }
        let proteinsView = self.contentView as! ProteinsView
        
        // network로 ligand 가져오는 부분 Domain에서 진행. (비즈니스 로직)
        // MVC로 처리할 것인지 network 모델 자체를 MVVM으로 할 것인지 고민.
        // 해당 data 처리 동안 indicator 적용.
        // 해당 data 처리가 완료되면 pdbDataProvider로 이전
        
        // parse PDB도 Domain으로 이전 예정(모듈화 -> 결과값만 가져다 쓸 예정.)
        // PDB 데이터를 파싱하여 SceneKit 노드를 생성
        let (proteinNode, atoms) = parsePDB(pdbData: pdbDataProvider.getPDBData())
        
        // 결합을 나타내는 노드 추가
        let bondNodes = createBonds(from: pdbDataProvider.getPDBData(), atoms: atoms)
        bondNodes.forEach { proteinNode.addChildNode($0) }
        
        // SceneKit 씬을 설정하고 proteinNode를 추가
        let scene = SCNScene()
        scene.rootNode.addChildNode(proteinNode)
        proteinsView.sceneView.scene = scene
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
