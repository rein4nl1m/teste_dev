import 'package:flutter/material.dart';
import 'package:news_app/data/model/news_model.dart';
import 'package:news_app/presentation/news/news_handle_page.dart';

import '../../presentation/home/home_page.dart';
import '../../presentation/splash/splash_screen.dart';
import 'app_routes.dart';

// ignore: public_member_api_docs
abstract class AppPageRouter {
  // ignore: public_member_api_docs
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case Routes.newsHandlePage:
        var item =
            settings.arguments != null ? settings.arguments as NewsModel : null;
        return MaterialPageRoute(
          builder: (_) => NewsHandlePage(
            news: item,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: const Text('Rota Inexistente'),
            ),
          ),
        );
    }
  }
}
