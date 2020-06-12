import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:xzn/states/profile_change_notifier.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xzn/style/base_theme.dart';
import 'page/login/login_choose.dart';
import 'app.dart';
import 'common/global.dart';
import 'loading.dart';

void main() => Global.init().then((e) {
//      AMapLocationClient.setApiKey("cb904fc25db7d0b715dabb813be2b6a0");
      runApp(MyApp());
    });

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    Locale myLocale = Localizations.localeOf(context);
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: UserModel()),
        ChangeNotifierProvider.value(value: MyOrderModel()),
        ChangeNotifierProvider.value(value: CartModel()),
        ChangeNotifierProvider.value(value: OrderModel()),
        ChangeNotifierProvider.value(value: AddressModel()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,

//          DemoLocalizationsDelegate(),
        ],
//        debugShowMaterialGrid: true,
//        showPerformanceOverlay: true,
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
        locale: Locale('zh', 'CH'),
        debugShowCheckedModeBanner: false,
        title: "鲜着呢",
        theme: base,
        routes: <String, WidgetBuilder>{
          "app": (context) => App(),
          "login": (context) => LoginChoose(),
          "about": (context) => WebviewScaffold(
                url: "https://www.bing.com",
                appBar: AppBar(
                  title: Text("关于我们"),
                  leading: IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {},
                  ),
                ),
              )
        },
        home: Center(
          child: LoadingPage(),
        ),
      ),
    );
  }
}
