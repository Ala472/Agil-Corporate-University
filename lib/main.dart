import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formagil_app_admin/models/former.dart';
import 'package:formagil_app_admin/screens/AdminUser.dart';
import 'package:formagil_app_admin/screens/CategoryScreen.dart';
import 'package:formagil_app_admin/screens/Former/screens/ProfilScreen.dart';
import 'package:formagil_app_admin/screens/Former/screens/ManageCourse.dart';
import 'package:formagil_app_admin/screens/Former/screens/LoginFormer.dart';
import 'package:formagil_app_admin/screens/HomeScreen.dart';
import 'package:formagil_app_admin/screens/LearnerScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:formagil_app_admin/screens/LoginScreen.dart';
import 'package:formagil_app_admin/screens/ManageFormer.dart';
import 'package:formagil_app_admin/screens/ProductScreen.dart';
import 'package:formagil_app_admin/screens/SplashScreen.dart';
import 'package:formagil_app_admin/screens/SurveyScreen.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:formagil_app_admin/services/firebase_services.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}
const ColorScheme _shrineColorScheme = ColorScheme(
  primary: shrinePink100,
  primaryVariant: shrineBrown900,
  secondary: shrinePink50,
  secondaryVariant: shrineBrown900,
  surface: shrineSurfaceWhite,
  background: shrineBackgroundWhite,
  error: shrineErrorRed,
  onPrimary: shrineBrown900,
  onSecondary: shrineBrown900,
  onSurface: shrineBrown900,
  onBackground: shrineBrown900,
  onError: shrineSurfaceWhite,
  brightness: Brightness.light,
);

const Color shrinePink50 = Color(0xFFFEEAE6);
const Color shrinePink100 = Color(0xffffde00);
const Color shrinePink300 = Color(0xffffde00);
const Color shrinePink400 = Color(0xFFEAA4A4);

const Color shrineBrown900 = Colors.black;
const Color shrineBrown600 = Colors.white;

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = Color(0xFF371911);
const Color shrineBackgroundWhite = Colors.white;

const defaultLetterSpacing = 0.03;

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if(settings.name == 'manage-former')
      return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}

class MyApp extends StatelessWidget {
  TextTheme _buildShrineTextTheme(TextTheme base) {
    return base
        .copyWith(
      caption: base.caption.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        letterSpacing: defaultLetterSpacing,
      ),
      button: base.button.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: defaultLetterSpacing,
      ),
    )
        .apply(
      fontFamily: 'Raleway',
      displayColor: shrineBrown900,
      bodyColor: shrineBrown900,
    );
  }
  ThemeData themeData() {

    final ThemeData base = ThemeData.light();
    return base.copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: _shrineColorScheme,
      accentColor: shrineBrown900,
      primaryColor: shrinePink100,
      buttonColor: shrinePink100,
      scaffoldBackgroundColor: shrineBackgroundWhite,
      cardColor: shrineBackgroundWhite,
      textSelectionColor: shrinePink100,
      errorColor: shrineErrorRed,
      buttonTheme: const ButtonThemeData(
        colorScheme: _shrineColorScheme,
        textTheme: ButtonTextTheme.normal,
      ),
      primaryIconTheme: _customIconTheme(base.iconTheme),
      textTheme: _buildShrineTextTheme(base.textTheme),
      primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
      iconTheme: _customIconTheme(base.iconTheme),
    );

  }
  IconThemeData _customIconTheme(IconThemeData original) {
    return original.copyWith(color: shrineBrown900);
  }


  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: DatabaseService(),
            ),
          ],
          child: StreamProvider<Former>.value(
            value: FirebaseServices().formerUser,
            child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Agil Corporate University',
                  theme: themeData(),
                  initialRoute: SplashScreen.id,
                  onGenerateRoute: (settings) {
                    switch (settings.name) {
                      case FormerScreen.id:
                        {
                          return MyCustomRoute(
                            builder: (_) => FormerScreen(),
                            settings: settings,
                          );
                        }
                      case CategoryScreen.id:
                        {
                          return MyCustomRoute(
                            builder: (_) => CategoryScreen(),
                            settings: settings,
                          );
                        }
                      case LearnerScreen.id:
                        {
                          return MyCustomRoute(
                            builder: (_) => LearnerScreen(),
                            settings: settings,
                          );
                        }
                      case SplashScreen.id:
                        {
                          return MyCustomRoute(
                            builder: (_) => SplashScreen(),
                            settings: settings,
                          );
                        }
                      case LoginScreen.id:
                        {
                          return MyCustomRoute(
                            builder: (_) => LoginScreen(),
                            settings: settings,
                          );
                        }
                      case SurveyScreen.id:
                        {
                          return MyCustomRoute(
                            builder: (_) => SurveyScreen(),
                            settings: settings,
                          );
                        }
                      case AdminUser.id:
                        {
                          return MyCustomRoute(
                            builder: (_) => AdminUser(),
                            settings: settings,
                          );
                        }
                      case ProductScreen.id:
                        {
                          return MyCustomRoute(
                            builder: (_) => ProductScreen(),
                            settings: settings,
                          );
                        }
                      case LoginFormer.id:
                        {
                          return MyCustomRoute(
                            builder: (_) => LoginFormer(),
                            settings: settings,
                          );
                        }
                      case ManageCourse.id:
                        {
                          return MyCustomRoute(
                            builder: (_) => ManageCourse(),
                            settings: settings,
                          );
                        }
                      case ProfilScreen.id:
                        {
                          return MyCustomRoute(
                            builder: (_) => ProfilScreen(),
                            settings: settings,
                          );
                        }

                      default: {
                        return MyCustomRoute(
                          builder: (_) => SplashScreen(),
                          settings: settings,
                        );
                      }
                    }
                  }

              ),
          ),
          ),
    );
  }
}
