import 'dart:async';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: EarthPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  ARKitController arKitController;

  @override
  void dispose() {
    // TODO: implement dispose
    arKitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    // appBar: AppBar(
    //   title: Text("AR test"),
    // ),
    body: ARKitSceneView(
      onARKitViewCreated: _onArKitViewCreated,
    ),
  );

  _onArKitViewCreated(ARKitController arkitController){
      this.arKitController=arkitController;
      final node = ARKitNode(
        geometry: ARKitSphere(radius: 100.0), position: vector.Vector3(0,0,0));
      this.arKitController.add(node);
      this.arKitController.add(ARKitNode(
          geometry: ARKitSphere(radius: 100.0), position: vector.Vector3(10,10,10)));
  }
}

class RealTimeUpdatesPage extends StatefulWidget {
  @override
  _RealTimeUpdatesPageState createState() => _RealTimeUpdatesPageState();
}

class _RealTimeUpdatesPageState extends State<RealTimeUpdatesPage> {
  ARKitController arkitController;
  ARKitNode movingNode;
  bool busy = false;

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Time Updates Sample'),
      ),
      body: Container(
        child: ARKitSceneView(
          onARKitViewCreated: _onARKitViewCreated,
        ),
      ),
    );
  }

  void _onARKitViewCreated(ARKitController arkitController) {
    final ARKitMaterial material = ARKitMaterial(
      diffuse: ARKitMaterialProperty(color: Colors.white),
    );

    final sphere = ARKitSphere(
      materials: [material],
      radius: 0.01,
    );

    movingNode = ARKitNode(
      geometry: sphere,
      position: vector.Vector3(0, 0, -0.25),
    );

    this.arkitController = arkitController;
    this.arkitController.updateAtTime = (time) {
      if (busy == false) {
        busy = true;
        this.arkitController.performHitTest(x: 0.25, y: 0.75).then((results) {
          if (results.isNotEmpty) {
            final point = results.firstWhere(
                    (o) => o.type == ARKitHitTestResultType.featurePoint,
                orElse: () => null);
            if (point == null) {
              return;
            }
            final position = vector.Vector3(
              point.worldTransform.getColumn(3).x,
              point.worldTransform.getColumn(3).y,
              point.worldTransform.getColumn(3).z,
            );
            final ARKitNode newNode = ARKitNode(
              geometry: sphere,
              position: position,
            );
            this.arkitController.remove(movingNode.name);
            movingNode = null;
            this.arkitController.add(newNode);
            movingNode = newNode;
          }
          busy = false;
        });
      }
    };

    this.arkitController.add(movingNode);
  }
}

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
      diffuse: ARKitMaterialProperty(image: 'earth.jpg'),
    );
    final sphere = ARKitSphere(
      materials: [material],
      radius: 0.1,
    );

    final node = ARKitNode(
      geometry: sphere,
      position: vector.Vector3(0, 0, -0.5),
      eulerAngles: vector.Vector3.zero(),
    );
    this.arkitController.add(node);

    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final rotation = node.eulerAngles;
      rotation.x += 0.01;
      node.eulerAngles = rotation;
    });
  }
}