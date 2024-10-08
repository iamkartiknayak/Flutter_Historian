import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

import './app_theme.dart';
import './features/clipboard/providers/clipboard_provider.dart';
import './features/emoji/providers/emoji_provider.dart';
import './features/emoticon/providers/emoticon_provider.dart';
import './features/home/pages/home_page.dart';
import './features/home/providers/home_provider.dart';
import './features/settings/providers/settings_provider.dart';
import './services/app_services.dart';
import './services/app_tray_service.dart';
import './services/snackbar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppServices().initData();

  FlutterWindowClose.setWindowShouldCloseHandler(() async {
    WindowManager.instance.hide();
    AppTrayService().rebuildAppTray(false);
    return AppTrayService.exitFlag == "terminate";
  });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(create: (_) => ClipboardProvider()),
      ChangeNotifierProvider(create: (_) => EmojiProvider()),
      ChangeNotifierProvider(create: (_) => EmoticonProvider()),
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
    ],
    child: const Historian(),
  ));
}

class Historian extends StatefulWidget {
  const Historian({super.key});

  @override
  State<Historian> createState() => _HistorianState();
}

class _HistorianState extends State<Historian> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    AppTrayService().initAppTray(context);
    AppServices().setContext(context);
    context.read<HomeProvider>().initControllers(this);
    context.read<ClipboardProvider>().initControllers(context);
    context.read<EmojiProvider>().initControllers(this, context);
    context.read<EmoticonProvider>().initControllers(this, context);
    context.read<SettingsProvider>().initControllers(this, context);

    final (accentColor, categoryOneRadius, categoryTwoRadius) = context.select(
      (SettingsProvider p) => (
        p.accentColor,
        p.categoryOneRadius,
        p.categoryTwoRadius,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Historian',
      theme: AppTheme.lightTheme(accentColor, (
        categoryOneRadius,
        categoryTwoRadius,
      )),
      darkTheme: AppTheme.darkTheme(accentColor, (
        categoryOneRadius,
        categoryTwoRadius,
      )),
      scaffoldMessengerKey: SnackBarService.scaffoldKey,
      home: SystemThemeBuilder(
        builder: (context, color) {
          AppTheme.setAccentPallete(context);
          AppTrayService().setTrayIconBrightness(context);
          return HomePage(key: homePageKey);
        },
      ),
    );
  }
}
