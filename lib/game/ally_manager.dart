import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:strikerFootballman/game/ally.dart';
import 'game.dart';
import 'knows_game_size.dart';
import '../models/ally_data.dart';

// This component class takes care of spawning new enemy components
// randomly from top of the screen. It uses the HasGameRef mixin so that
// it can add child components.
class AllyManager extends Component
    with KnowsGameSize, HasGameRef<MasksweirdGame> {
  // The timer which runs the enemy spawner code at regular interval of time.
  late Timer _timer;

  // A reference to spriteSheet contains enemy sprites.
  SpriteSheet spriteSheet;

  // Holds an object of Random class to generate random numbers.
  Random random = Random();

  AllyManager({required this.spriteSheet}) : super() {
    _timer = Timer(2, onTick: _spawnAlly, repeat: true);
  }

  // Spawns a new enemy at random position at the top of the screen.
  void _spawnAlly() {
    Vector2 initialSize = Vector2(100 / 1.4, 100 / 1.4);

    // random.nextDouble() generates a random number between 0 and 1.
    // Multiplying it by gameRef.size.x makes sure that the value remains between 0 and width of screen.
    // Vector2 position = Vector2(gameRef.size.x - 32,
    //     (gameRef.size.y - gameRef.size.y / 3) - 500 * random.nextDouble());

    // Make sure that we have a valid BuildContext before using it.
    if (gameRef.buildContext != null) {
      // Get current score and figure out the max level of enemy that
      // can be spawned for this score.

      /// Gets a random [EnemyData] object from the list.
      final enemyData = _enemyDataList.elementAt(random.nextInt(5));
      Vector2 position = Vector2(gameRef.size.x - 32,
          (gameRef.size.y - (gameRef.size.y / 2) + enemyData.psn));
      Ally enemy = Ally(
        sprite: spriteSheet.getSpriteById(enemyData.spriteId),
        size: initialSize,
        position: position,
        allyData: enemyData,
      );

      // Makes sure that the enemy sprite is centered.
      enemy.anchor = Anchor.center;

      // Add it to components list of game instance, instead of EnemyManager.
      // This ensures the collision detection working correctly.
      gameRef.add(enemy);
    }
  }

  @override
  void onMount() {
    super.onMount();
    // Start the timer as soon as current enemy manager get prepared
    // and added to the game instance.
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    // Stop the timer if current enemy manager is getting removed from the
    // game instance.
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update timers with delta time to make them tick.
    _timer.update(dt);
  }

  // Stops and restarts the timer. Should be called
  // while restarting and exiting the game.
  void reset() {
    _timer.stop();
    _timer.start();
  }

  /// A private list of all [AllyData]s.
  static const List<AllyData> _enemyDataList = [
    AllyData(
      killPoint: 1,
      speed: 350,
      spriteId: 0,
      level: 1,
      hMove: false,
      psn: 0,
    ),
    AllyData(
      killPoint: 1,
      speed: 350,
      spriteId: 1,
      level: 1,
      hMove: true,
      psn: 100,
    ),
    AllyData(
      killPoint: 1,
      speed: 350,
      spriteId: 0,
      level: 1,
      hMove: false,
      psn: 130,
    ),
    AllyData(
      killPoint: 1,
      speed: 500,
      spriteId: 1,
      level: 1,
      hMove: true,
      psn: 100,
    ),
    AllyData(
      killPoint: 1,
      speed: 450,
      spriteId: 0,
      level: 1,
      hMove: false,
      psn: 0,
    ),
  ];
}
