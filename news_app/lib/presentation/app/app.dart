import 'package:flutter/material.dart';
import 'package:news_app/core/blocs/news_bloc.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_page_router.dart';
import '../../core/routes/app_routes.dart';

// ignore: public_member_api_docs
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsBloc>(
          create: (_) => NewsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'News App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Routes.splash,
        onGenerateRoute: AppPageRouter.generateRoute,
      ),
    );
  }
}
