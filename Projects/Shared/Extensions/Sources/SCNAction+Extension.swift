//
//  SCNAction+Extension.swift
//  SharedExtensions
//
//  Created by Chan on 6/19/24.
//

import SceneKit

public extension SCNAction {
    static func rotateAround(_ position: SCNVector3, byAngle angle: CGFloat, duration: TimeInterval) -> SCNAction {
        let node = SCNNode()
        node.position = position
        return SCNAction.customAction(duration: duration) { (node, elapsedTime) in
            let fraction = elapsedTime / CGFloat(duration)
            let currentAngle = fraction * angle
            node.position = SCNVector3(
                x: Float(cos(currentAngle)) * 10,
                y: 10,
                z: Float(sin(currentAngle)) * 10
            )
        }
    }
}
