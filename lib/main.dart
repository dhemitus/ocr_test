import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:police/controller/controller.dart';
import 'package:police/modules/modules.dart';
import 'package:camera/camera.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Police Number Test Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: AppBinding(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<CameraDescription> _cameras;

  Future<void> _direct() async {
    _cameras = await availableCameras();

    Get.to(VisionPage(_cameras));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'scan police number testing',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() => _direct(),
        tooltip: 'Increment',
        child: const Icon(
          Icons.document_scanner_outlined,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

