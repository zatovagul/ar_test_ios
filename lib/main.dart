import 'dart:async';

import 'package:ar_test_ios/pages/earth_page.dart';
import 'package:ar_test_ios/pages/face_detection_page.dart';
import 'package:ar_test_ios/pages/realtime_updates_page.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: FaceDetectionPage(),
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