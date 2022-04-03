import 'dart:async';

// import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import '../api/api.dart';
import '../pages/home_page.dart';
import '../pages/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
// import 'package:page_transition/page_transition.dart';

Future<void> main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => API()..init(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return MaterialApp(
            theme: ThemeData(
              primaryColor: const Color(0xff7579e7),
              hoverColor: Color.fromARGB(255, 58, 62, 182),
              backgroundColor: Color.fromARGB(255, 236, 248, 255),
              canvasColor: const Color(0xff9ab3f5),
            ),
            home: MySplashScreen()
            // home: HomePage(),
            // SplashScreen(
            //   seconds: 3,
            //   photoSize: 100.0.sp,
            //   title: Text(
            //     "Alphacoders+",
            //     // maxLines: 5,
            //     style: TextStyle(
            //         fontSize: 30.0.sp,
            //         color: Color(0xff7FC9FD),
            //         shadows: [
            //           Shadow(
            //               color: Colors.black,
            //               offset: Offset(3, 4),
            //               blurRadius: 10)
            //         ],
            //         fontStyle: FontStyle.italic,
            //         letterSpacing: 3.0,
            //         fontWeight: FontWeight.bold,
            //         fontFamily: "Tahoma"),
            //   ),
            //   backgroundColor: Color(0xffe1f5fe),
            //   navigateAfterSeconds: HomePage(),
            //   loadingText: Text(
            //     "powered by wallpaperabyss.com",
            //     style: TextStyle(
            //         fontSize: 15.0.sp,
            //         color: Colors.blue,
            //         // shadows: [
            //         //   Shadow(
            //         //       color: Colors.black,
            //         //       offset: Offset(3, 4),
            //         //       blurRadius: 10)
            //         // ],
            //         // fontStyle: FontStyle.italic,
            //         // letterSpacing: 3.0,
            //         // fontWeight: FontWeight.bold,
            //         fontFamily: "Tahoma"),
            //   ),
            //   useLoader: false,
            //   image: const Image(
            //     image: AssetImage("assets/images/logo.png"),
            //   ),
            // )

            // home: AnimatedSplashScreen(
            //   // centered: false,
            //   nextScreen: HomePage(),
            //   splash: "assets/images/categories/Game.png",
            //   splashTransition: SplashTransition.scaleTransition,
            // ),
            );
      },
    );
  }
}
