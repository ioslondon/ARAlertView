# ARAlertView
Animated Alert View for ARKit with editable text and button title.


Drag and Drop the ARAlertView.swift file in your app folders and the ARAlertView.scn asset in your art.scnassets folder.


in your view controller, initialise 

let arAlertView = ARAlertView(alertText: "Alert text here", buttonText: "OK", buttonColor: .blue)


then call arAlertView.show(in : sceneView) to show the alert

then perform a hit test on the scene to remove by calling 

arAlertView.remove(from: sceneView)

