import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:strikerFootballman/game/bullet.dart';
import 'package:provider/provider.dart';

import '../models/player_data.dart';

import 'game.dart';
import 'enemy.dart';
import 'knows_game_size.dart';

enum PlayerState { stopped1, stopped2, jumping, reverse, zero }

// This component class represents the player character in game.
class Player extends SpriteAnimationComponent
    with
        KnowsGameSize,
        CollisionCallbacks,
        HasGameRef<MasksweirdGame>,
        KeyboardHandler {
  PlayerState playerState = PlayerState.zero;
  // Player health.
  int _health = 100;
  int get health => _health;
  bool isRunning = false;
  // A reference to PlayerData so that
  // JoystickComponent joystick;
  late PlayerData _playerData;
  int get score => _playerData.currentScore;
  var moveDirection = 1;
  Player({
    // required this.joystick,
    SpriteAnimation? animation,
    Vector2? position,
    Vector2? size,
  }) : super(animation: animation, position: position, size: size);

  @override
  void onMount() async {
    super.onMount();

    // Adding a circular hitbox with radius as 0.8 times
    // the smallest dimension of this components size.
    final shape = RectangleHitbox.relative(
      Vector2(0.6, 1),
      parentSize: Vector2(super.size.x * 0.6, super.size.y * 0.3),
      position: Vector2(super.size.x / 2, super.size.y / 2),
      anchor: Anchor.bottomCenter,
    );
    add(shape);

    _playerData = Provider.of<PlayerData>(gameRef.buildContext!, listen: false);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position
        .add(Vector2(-0.2 * moveDirection, -0.7 * moveDirection) * 200 * dt);

    if (position.y < 280) {
      moveDirection = -1;
    }
    if (position.y > gameRef.size.y - 400) {
      moveDirection = 1;
    }

    if (playerState == PlayerState.stopped1) {}
    if (playerState == PlayerState.stopped2) {}
    if (playerState == PlayerState.zero) {}
    // Clamp position of player such that the player sprite does not go outside the screen size.
    position.clamp(
      Vector2.zero() + size / 2,
      gameRef.size - size / 2,
    );
  }

  // Adds given points to player score
  /// and also add it to [PlayerData.money].
  void addToScore(int points) {
    _playerData.currentScore += points;
    _playerData.money += points;

    // Saves player data to disk.
    _playerData.save();
  }

  // Increases health by give amount.
  void increaseHealthBy(int points) {
    _health += points;
    // Clamps health to 100.
    if (_health > 100) {
      _health = 100;
    }
  }

  // Resets player score, health and position. Should be called
  // while restarting and exiting the game.
  void reset() {
    _playerData.currentScore = 0;
    _health = 100;
    // position = gameRef.size / 2;
  }

  void jump() async {
    Bullet bullet = Bullet(
        animation: gameRef.fire,
        size: Vector2(80 / 2, 80 / 2),
        position: Vector2(gameRef.size.x - gameRef.size.x / 8,
            gameRef.size.y - gameRef.size.y / 6));

    // Anchor it to center and add to game world.
    bullet.anchor = Anchor.bottomCenter;
    if (isRunning == false) {
      gameRef.add(bullet);
    }
  }
}
