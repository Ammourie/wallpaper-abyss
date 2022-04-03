import 'package:alphac/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MySplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => HomePage(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 1000),
          ));
    });
    return Scaffold(
      backgroundColor: const Color(0xffe1f5fe),
      body: Stack(
        children: [
          SizedBox(
            width: 100.0.w,
            height: 100.0.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60.0.w,
                  height: 70.0.w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Alphacoders+",
                  // maxLines: 5,
                  style: TextStyle(
                      fontSize: 30.0.sp,
                      color: const Color(0xff7FC9FD),
                      shadows: const [
                        Shadow(
                            color: Colors.black,
                            offset: Offset(3, 4),
                            blurRadius: 10)
                      ],
                      fontStyle: FontStyle.italic,
                      letterSpacing: 3.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Tahoma"),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            child: SizedBox(
              width: 100.0.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "powered by ",
                    style: TextStyle(
                        fontSize: 13.0.sp,
                        color: Colors.black45,
                        fontFamily: "Tahoma"),
                  ),
                  Text(
                    "Wallpaper Abyss",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 13.0.sp,
                        color: const Color(0xff7FC9FD),
                        fontFamily: "Tahoma"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
