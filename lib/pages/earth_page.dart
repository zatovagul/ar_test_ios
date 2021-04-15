import 'dart:async';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class EarthPage extends StatefulWidget {
  @override
  _EarthPageState createState() => _EarthPageState();
}

class _EarthPageState extends State<EarthPage> {
  ARKitController arkitController;
  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Earth Sample')),
    body: Container(
      child: ARKitSceneView(
        onARKitViewCreated: onARKitViewCreated,
      ),
    ),
  );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;

    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.lambert,
      diffuse: ARKitMaterialProperty(image: 'https://atlas-content-cdn.pixelsquid.com/stock-images/marijuana-bud-mda4Xn1-600.jpg'),
    );
    final sphere = ARKitSphere(
      materials: [material],
      radius: 0.1,
    );

    final node = ARKitNode(
      geometry: sphere,
      position: vector.Vector3(0, 0, -1),
      eulerAngles: vector.Vector3.zero(),
    );
    this.arkitController.add(node);

    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final rotation = node.eulerAngles;
      //rotation.x += 0.01;
      node.eulerAngles = rotation;
      node.position=vector.Vector3(node.position.x+0.001,node.position.y, node.position.z);
    });
  }
}