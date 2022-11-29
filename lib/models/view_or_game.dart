import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

part 'view_or_game.g.dart';

@HiveType(typeId: 3)
class ViewOrGameData extends ChangeNotifier with HiveObjectMixin {
  static const String viewOrGameBox = 'ViewOrGameBox';
  static const String viewOrGameKey = 'viewOrGameData';

  @HiveField(0)
  bool _startedView = false;
  bool get startedView => _startedView;
  set startedView(bool value) {
    _startedView = value;
    notifyListeners();
    save();
  }

  @HiveField(1)
  bool _startedGame = false;
  bool get startedGame => _startedGame;
  set startedGame(bool value) {
    _startedGame = value;
    notifyListeners();
    save();
  }

  ViewOrGameData({
    bool startedView = false,
    bool startedGame = false,
  })  : _startedView = startedView,
        _startedGame = startedGame;
}
