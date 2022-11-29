import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:strikerFootballman/game/records/bloc/records_bloc.dart';
import 'package:provider/provider.dart';
import 'package:strikerFootballman/app_state.dart';
import 'package:strikerFootballman/models/view_or_game.dart';
import 'package:strikerFootballman/screens/where_to_go.dart';
import 'package:strikerFootballman/screens/no_internet_screen.dart';
import 'package:strikerFootballman/utils/network.dart';

import 'models/settings.dart';
import 'models/player_data.dart';
import 'models/spaceship_details.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  AppState();
  await isInternetConnectionAvailable()
      ? {
          await FirebaseRemoteConfig.instance
              .setConfigSettings(RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 5),
            minimumFetchInterval: Duration.zero,
          )),
          await FirebaseRemoteConfig.instance.fetchAndActivate()
        }
      : null;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Flame.device.fullScreen();
  await initHive();

  runApp(MultiProvider(
    providers: [
      FutureProvider<PlayerData>(
        create: (BuildContext context) => getPlayerData(),
        initialData: PlayerData.fromMap(PlayerData.defaultData),
      ),
      FutureProvider<Settings>(
        create: (BuildContext context) => getSettings(),
        initialData: Settings(soundEffects: false, backgroundMusic: false),
      ),
      FutureProvider<ViewOrGameData>(
        create: (BuildContext context) => getViewOrGame(),
        initialData: ViewOrGameData(startedGame: false, startedView: false),
      ),
    ],
    builder: (context, child) {
      return MultiProvider(
        providers: [
          BlocProvider<RecordsBloc>(
            create: (_) => RecordsBloc(),
            lazy: false,
          ),
          ChangeNotifierProvider<PlayerData>.value(
            value: Provider.of<PlayerData>(context),
          ),
          ChangeNotifierProvider<Settings>.value(
            value: Provider.of<Settings>(context),
          ),
          ChangeNotifierProvider<ViewOrGameData>.value(
            value: Provider.of<ViewOrGameData>(context),
          ),
        ],
        child: child,
      );
    },
    child: ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.orange,
                ),
              ),
              themeMode: ThemeMode.dark,
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                fontFamily: 'LibreBaskerville',
                scaffoldBackgroundColor: Colors.black,
              ),
              home: AppState().isInternetOn
                  ? const WhereToGoWidget()
                  : const NoInternetWidget());
        }),
  ));
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ViewOrGameAdapter());

  Hive.registerAdapter(PlayerDataAdapter());
  Hive.registerAdapter(SpaceshipTypeAdapter());
  Hive.registerAdapter(SettingsAdapter());
}

/// This function reads the stored [PlayerData] from disk.
Future<PlayerData> getPlayerData() async {
  // Open the player data box and read player data from it.
  final box = await Hive.openBox<PlayerData>(PlayerData.playerDataBox);
  final playerData = box.get(PlayerData.playerDataKey);

  // If player data is null, it means this is a fresh launch
  // of the game. In such case, we first store the default
  // player data in the player data box and then return the same.
  if (playerData == null) {
    box.put(
      PlayerData.playerDataKey,
      PlayerData.fromMap(PlayerData.defaultData),
    );
  }

  return box.get(PlayerData.playerDataKey)!;
}

/// This function reads the stored [ViewOrGameData] from disk.
Future<ViewOrGameData> getViewOrGame() async {
  // Open the settings box and read settings from it.
  final box = await Hive.openBox<ViewOrGameData>(ViewOrGameData.viewOrGameBox);
  final viewOrGame = box.get(ViewOrGameData.viewOrGameKey);

  // If settings is null, it means this is a fresh launch
  // of the game. In such case, we first store the default
  // settings in the settings box and then return the same.
  if (viewOrGame == null) {
    box.put(ViewOrGameData.viewOrGameKey,
        ViewOrGameData(startedView: false, startedGame: false));
  }
  if (viewOrGame?.startedGame == true) {
    AppState().isDevMode = true;
  }
  return box.get(ViewOrGameData.viewOrGameKey)!;
}

/// This function reads the stored [Settings] from disk.
Future<Settings> getSettings() async {
  // Open the settings box and read settings from it.
  final box = await Hive.openBox<Settings>(Settings.settingsBox);
  final settings = box.get(Settings.settingsKey);

  // If settings is null, it means this is a fresh launch
  // of the game. In such case, we first store the default
  // settings in the settings box and then return the same.
  if (settings == null) {
    box.put(Settings.settingsKey,
        Settings(soundEffects: true, backgroundMusic: true));
  }

  return box.get(Settings.settingsKey)!;
}
