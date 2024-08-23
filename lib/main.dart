import 'package:ecommerce_portal/screens/login.dart';
import 'package:ecommerce_portal/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/cart/cart_bloc.dart';
import 'screens/home_page.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(create: (context) => CartBloc()),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(cartBloc: BlocProvider.of<CartBloc>(context)),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: ThemeData(
          primaryColor: Colors.orange,
          hintColor: Colors.blueAccent,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.orange,
            textTheme: ButtonTextTheme.primary,
          ),
          appBarTheme: AppBarTheme(
            color: Colors.orange,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          textTheme: TextTheme(
            displayLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 18.0),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/home': (context) => HomePage(), // Updated to HomeScreen with BottomNavBar
        },
      ),
    );
  }
}
