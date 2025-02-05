import 'package:flutter/material.dart';
import 'package:plan_dimensions/plan_dimensions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PlanDimensionsWidget(
      phoneMinSideDesignPoints: 608.0, //The smallest side of the phone screen in design points
      tabletMinSideDesignPoints: 1080.0, //The smallest side of the tablet screen in design points
      desktopMinSideDesignPoints: 1444.0, //The smallest side of the desktop screen in design points
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Container(
              width: 300.toLp,
              height: 300.toLp,
              color: Colors.red,
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              width: 300,
              height: 300,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
