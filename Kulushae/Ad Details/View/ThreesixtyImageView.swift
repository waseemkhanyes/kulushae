//
//  ThreesixtyImageView.swift
//  Kulushae
//
//  Created by ios on 22/11/2023.
//

import SwiftUI
import SceneKit

struct ThreeSixtyImageView: UIViewRepresentable {
    @State private var panoramicImage: UIImage?

     func makeCoordinator() -> Coordinator {
         Coordinator(self)
     }

     func makeUIView(context: Context) -> SCNView {
         let sceneView = SCNView()
         sceneView.scene = createScene()
         sceneView.allowsCameraControl = true
         sceneView.autoenablesDefaultLighting = true
         sceneView.delegate = context.coordinator
         return sceneView
     }

     func updateUIView(_ uiView: SCNView, context: Context) {
         if let panoramicImage = panoramicImage {
             uiView.scene?.rootNode.childNodes.first?.geometry?.firstMaterial?.diffuse.contents = panoramicImage
         }
     }

     func createScene() -> SCNScene {
         let scene = SCNScene()

         // Create a panoramic plane with initial size
         let initialWidth = UIScreen.main.bounds.width
         let initialHeight = initialWidth / 2.0
         let plane = SCNPlane(width: initialWidth, height: initialHeight)
         let panoramicMaterial = SCNMaterial()
         panoramicMaterial.diffuse.contents = UIColor.gray // Placeholder color while loading
         plane.materials = [panoramicMaterial]

         // Create a node with the plane
         let planeNode = SCNNode(geometry: plane)
         planeNode.eulerAngles = SCNVector3(x: 0, y: 0, z: 0) // Adjust the orientation if needed

         // Add the plane node to the scene
         scene.rootNode.addChildNode(planeNode)


           // Load the image from URL
           if let url = URL(string: "https://img.freepik.com/premium-photo/aerial-panoramic-view-vilnius-old-town-business-district-river-neris-lithuania_272335-1413.jpg?w=2000") {
               URLSession.shared.dataTask(with: url) { data, _, error in
                              if let data = data, let image = UIImage(data: data) {
                                  DispatchQueue.main.async {
                                      self.panoramicImage = image
                                      // Resize the plane to match the image size
                                      let imageWidth = image.size.width
                                      let imageHeight = image.size.height
                                      plane.width = imageWidth
                                      plane.height = imageHeight
                                  }
                              }
                          }.resume()
           }

           return scene
       }

       class Coordinator: NSObject, SCNSceneRendererDelegate {
           var parent: ThreeSixtyImageView

           init(_ parent: ThreeSixtyImageView) {
               self.parent = parent
           }

           func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
               // Update code here if needed
           }
       }
   }
