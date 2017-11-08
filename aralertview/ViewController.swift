//
//  ViewController.swift
//  aralertview
//
//  Created by Romain on 08/11/2017.
//  Copyright © 2017 iOS London. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
	let alert = ARAlert(alertText: "this is working!", buttonText: "whatever")

	//MARK: INTERACTIONS
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.location(in: sceneView)
			let hitList = sceneView.hitTest(location, options: nil)
			if let node = hitList.first?.node {
				if node.geometry?.name == "button" {
					alert.remove(from: sceneView)
				}
				
			} else {
				alert.add(to: sceneView)
			}
		}
	}

	//MARK : APP LIFE CYCLE
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		sceneView.delegate = self
		let scene = SCNScene()
		sceneView.scene = scene
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let configuration = ARWorldTrackingConfiguration()
		sceneView.session.run(configuration)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		sceneView.session.pause()
	}
	
}
