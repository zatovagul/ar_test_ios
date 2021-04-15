import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:arkit_plugin/utils/json_converters.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class FaceDetectionPage extends StatefulWidget {
  @override
  _FaceDetectionPageState createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  ARKitController arkitController;
  ARKitNode node;
  String anchorId;

  ARKitNode leftEye;
  ARKitNode rightEye;

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        //appBar: AppBar(title: const Text('Face Detection Sample')),
        body: Container(
          child: ARKitSceneView(
            configuration: ARKitConfiguration.faceTracking,
            onARKitViewCreated: onARKitViewCreated,
          ),
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;
  }

  void _handleAddAnchor(ARKitAnchor anchor) {
    if (!(anchor is ARKitFaceAnchor)) {
      return;
    }
    // final material = ARKitMaterial(
    //   fillMode: ARKitFillMode.fill,
    //   diffuse: ARKitMaterialProperty(
    //     image:
    //         'https://free-png.ru/wp-content/uploads/2019/05/Logotip-instagram-t.png',
    //   ),
    // );
    final ARKitFaceAnchor faceAnchor = anchor;
    final material=ARKitMaterial(
        fillMode: ARKitFillMode.lines,
    );
    faceAnchor.geometry.materials.value = [material];

    anchorId = anchor.identifier;
    node = ARKitNode(geometry: faceAnchor.geometry);
    arkitController.add(node, parentNodeName: anchor.nodeName);

    // leftEye = _createEye(faceAnchor.leftEyeTransform, "https://www.freeiconspng.com/thumbs/eye-png/real-brown-eye-png-10.png");
    // arkitController.add(leftEye, parentNodeName: anchor.nodeName);
    // rightEye = _createEye(faceAnchor.rightEyeTransform, "https://lh3.googleusercontent.com/proxy/OuFqDjW5OUyJvWAHkDrUzsaJqHSEOX2yvjhgIcMMv9e94LcNIsWj16YJC0CGKA1fdXnvUQN3Yl80ajtmxtgT0lVDCJfcpn5nxp5O7AJ_UFPNAQRXhlrK");
    // arkitController.add(rightEye, parentNodeName: anchor.nodeName);
  }

  ARKitNode _createEye(Matrix4 transform,[String url=""]) {
    final position = vector.Vector3(
      transform.getColumn(3).x,
      transform.getColumn(3).y,
      transform.getColumn(3).z,
    );
    final material = ARKitMaterial(
      diffuse: ARKitMaterialProperty(image:url),
    );
    final sphere = ARKitSphere(
        materials: [material], radius: 0.007);

    return ARKitNode(geometry: sphere, position: position);
  }

  void _handleUpdateAnchor(ARKitAnchor anchor) {
    if (anchor is ARKitFaceAnchor) {
      final ARKitFaceAnchor faceAnchor = anchor;
      arkitController.updateFaceGeometry(node, anchor.identifier);
      // _updateEye(leftEye, faceAnchor.leftEyeTransform,
      //     faceAnchor.blendShapes['eyeBlink_L']);
      // _updateEye(rightEye, faceAnchor.rightEyeTransform,
      //     faceAnchor.blpes['eyeBlink_R']);
    }
  }

  void _updateEye(ARKitNode node, Matrix4 transform, double blink) {
    final scale = vector.Vector3(1, 1 - blink, 1);
    node.scale = scale;
  }
}
