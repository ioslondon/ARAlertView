//
//  ARAlert.swift
//  ARAlert
//
//  Created by Romain on 07/11/2017.
//  Copyright © 2017 ubicolor. All rights reserved.
//

import ARKit

class ARAlert : SCNNode {
	var alertText : String
	var buttonText : String
	fileprivate var translation = matrix_identity_float4x4
	
	
	init(alertText: String, buttonText: String) {
		self.alertText = alertText
		self.buttonText = buttonText
		super.init()
		self.name = "alertView"
		
	}
	
	func add(to sceneView : ARSCNView) {
		self.translation.columns.3.z = -2
		self.translation.columns.3.y = 0
		guard let pov = sceneView.session.currentFrame?.camera.transform else {return}
		let scene = SCNScene(named: "art.scnassets/aralert.scn")!
		guard let alertNode = scene.rootNode.childNode(withName: "alertView", recursively: false) else {return}
		if let textGeo = alertNode.childNode(withName: "textLabel", recursively: true)?.geometry as? SCNText {
			textGeo.string = alertText
		}
		alertNode.simdTransform = matrix_multiply(pov, translation)
		sceneView.scene.rootNode.addChildNode(alertNode)
		
		let physicsBody = SCNPhysicsBody(type: .dynamic , shape: nil)
		//physicsBody.velocity = SCNVector3Make(1, 0, 0)
		self.physicsBody = physicsBody
		
		self.translation.columns.3.z = -1
		self.translation.columns.3.y = 0
		let newTransformThirdColumn = matrix_multiply(pov, translation).columns.3
		let newPos = SCNVector3Make(newTransformThirdColumn.x, newTransformThirdColumn.y, newTransformThirdColumn.z)
		let move = SCNAction.move(to: newPos, duration: 1)
		let fadein = SCNAction.fadeIn(duration: 1)
		let group = SCNAction.group([move,fadein])
		self.runAction(group)
		

	}
	func remove(from sceneView: ARSCNView) {
		self.translation.columns.3.z = -5
		self.translation.columns.3.y = 3
		
		for node in sceneView.scene.rootNode.childNodes {
			if node.name == "alertView" {
				guard let pov = sceneView.session.currentFrame?.camera.transform else {return}
				let newTransformThirdColumn = matrix_multiply(pov, translation).columns.3
				let newPos = SCNVector3Make(newTransformThirdColumn.x, newTransformThirdColumn.y, newTransformThirdColumn.z)
				let move = SCNAction.move(to: newPos, duration: 0.3)
				let disapear = SCNAction.fadeOut(duration: 0.3)
				let sequence = SCNAction.sequence([move, disapear])
				node.runAction(sequence)
				let when = DispatchTime.now() + 0.6
				DispatchQueue.main.asyncAfter(deadline: when) {
					node.removeFromParentNode()
				}
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
