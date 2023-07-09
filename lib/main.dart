import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsms/providers/auth.dart';
import 'package:rsms/providers/products_provider.dart';
import 'package:rsms/providers/reports.dart';
import 'package:rsms/screens/ad-details-screen.dart';
import 'package:rsms/screens/list-screen.dart';
import 'package:rsms/screens/post-ad.dart';
import 'package:rsms/screens/search-screen.dart';
import 'package:rsms/screens/signup-screen.dart';
import 'package:rsms/screens/tab_screen.dart';
import 'package:rsms/screens/welcome-screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (context) => report.fromRep(),
          ),
          ChangeNotifierProxyProvider<Auth, report>(
            create: (context) => report.fromRep(),
            update: (context, auth, prevads) => report.fromad(
                auth.token,
                prevads == null ? [] : prevads.reports,
                auth.userId,
                auth.userEmail),
          ),
          ChangeNotifierProxyProvider<Auth, ad>(
            create: (context) => ad.fromadd(),
            update: (context, auth, prevads) => ad.fromad(
                auth.token,
                prevads == null ? [] : prevads.items,
                auth.userId,
                auth.userEmail),
          ),
        ],
        child: Consumer<Auth>(
            builder: (context, auth, _) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'MyShop',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home:
                      // MyHomePage(),

                      auth.isAuth ? BottomNavBar() : AuthScreen(),
                  routes: {
                    BottomNavBar.routeName: (ctx) => BottomNavBar(),
                    AuthScreen.routeName: (ctx) => AuthScreen(),
                    WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
                    ListScreen.routeName: (ctx) => ListScreen(),
                    PostAd.routeName: (ctx) => PostAd(),
                    SearchScreen.routeName: (ctx) => SearchScreen(),
                    ProductDetailScreen.routeName: (ctx) =>
                        ProductDetailScreen(),
                  },
                )));
  }
}
