import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/widgets/SplashScreen.dart';
import 'usePreferences/userPreferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: RememberUserPrefs.readUserInfo().then(
        (userInfo) => Future.delayed(Duration(seconds: 3), () => userInfo),
      ),
      builder: (context, dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Application",
            initialRoute: dataSnapShot.data == null ? Routes.LOGIN : Routes.HOME,
            getPages: AppPages.routes,
          );
        }
      },
    );

    /* return FutureBuilder(
      future: RememberUserPrefs.readUserInfo().then(
        (userData) => Future.delayed(Duration(seconds: 3), () => userData),
      ),
      builder: (context, dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        } else {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Application",
            initialRoute: dataSnapShot.data == null ? Routes.LOGIN : Routes.HOME,
            getPages: AppPages.routes,
          );
        }
      },
    ); */

    /*  return FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          } else {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Application",
              initialRoute: Routes.LOGIN,
              getPages: AppPages.routes,
            );
          }
        }); */

  }
}

