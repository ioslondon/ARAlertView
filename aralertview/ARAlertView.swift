//
//  ARAlertView.swift
//  ARAlertView
//
//  Created by Romain on 07/11/2017.
//  Copyright © 2017 ubicolor. All rights reserved.
//

import ARKit

class ARAlertView : SCNNode {
	var alertText : String
	var buttonText : String
	var buttonColor : UIColor
	fileprivate var translation = matrix_identity_float4x4
	
	init(alertText: String, buttonText: String, buttonColor: UIColor) {
		self.alertText = alertText
		self.buttonText = buttonText
		self.buttonColor = buttonColor
		super.init()
		self.name = "alertView"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func add(to sceneView : ARSCNView) {
		self.translation.columns.3.z = -2
		self.translation.columns.3.y = 0
		guard let pov = sceneView.session.currentFrame?.camera.transform else {return}
		let scene = SCNScene(named: "art.scnassets/ARAlertView.scn")!
		guard let alertNode = scene.rootNode.childNode(withName: "ARAlertView", recursively: false) else {return}
		if let arLabel = alertNode.childNode(withName: "ARLabel", recursively: true) {
			let textGeo = arLabel.geometry as? SCNText
			textGeo?.string = alertText
			let box = textGeo!.boundingBox
			arLabel.position = SCNVector3Make(-(box.min.x + box.max.x) / 200, -(box.min.y + box.max.y) / 200, 0.05)
		}
		if let arButtonTitle = alertNode.childNode(withName: "ARButtonTitle", recursively: true) {
			let buttonGeo = arButtonTitle.geometry as? SCNText
			buttonGeo?.string = buttonText
			let boundingBox = buttonGeo!.boundingBox

			arButtonTitle.position = SCNVector3Make(-(boundingBox.min.x + boundingBox.max.x) / 200, -(boundingBox.min.y + boundingBox.max.y) / 200, 0.05)
		}
		
		if let ARbutton = alertNode.childNode(withName: "ARButton", recursively: true) {
			ARbutton.geometry?.firstMaterial?.diffuse.contents = buttonColor
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
			if node.name == "ARAlertView" {
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
	
	
}
