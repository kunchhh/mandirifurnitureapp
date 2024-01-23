import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/widgets/SplashScreen.dart';
import 'usePreferences/userPreferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51OZCcEFN8Hx9mwWIiH7gUTTV0IQhEf1Il6wz67j0mJ4XmfcQZQqwFxjCr7lyADQK6U4Gjysqo65VCeDcQDsdsEzc00kORuVs4C';
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
  }
}

