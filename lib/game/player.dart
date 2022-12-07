import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:strikerFootballman/game/ally.dart';
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

  // A reference to PlayerData so that
  JoystickComponent joystick;
  late PlayerData _playerData;
  int get score => _playerData.currentScore;

  Player({
    required this.joystick,
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
      Vector2(0.5, 1),
      parentSize: Vector2(super.size.x * 0.5, super.size.y * 1),
      position: Vector2(super.size.x / 2, super.size.y),
      anchor: Anchor.centerRight,
    );
    add(shape);

    _playerData = Provider.of<PlayerData>(gameRef.buildContext!, listen: false);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // if (other is Enemy &&
    //     !gameRef.player.animation!.isLastFrame &&
    //     gameRef.player.animation == gameRef.animationKick) {
    //   // Make the camera shake, with custom intensity.

    //   Bullet bullet = Bullet(
    //       animation: gameRef.fire,
    //       size: Vector2(104 / 2, 101 / 2),
    //       position: Vector2(
    //           gameRef.player.position.x + 32, gameRef.player.position.y + 62));

    //   // Anchor it to center and add to game world.
    //   bullet.anchor = Anchor.bottomCenter;

    //   gameRef.add(bullet);

    //   _health -= 10;
    //   if (_health <= 0) {
    //     _health = 0;
    //   }

    // }
  }

  // This method is called by game class for every frame.
  @override
  void update(double dt) {
    super.update(dt);
    // if (playerState == PlayerState.jumping) {
    //   gameRef.player.animation = gameRef.animationKick;
    // }
    if (joystick.delta.x == 0 && playerState != PlayerState.jumping) {
      // gameRef.animationKick.reset();
      gameRef.player.animation = gameRef.no_fire;
      gameRef.animationJump.reset();
      gameRef.animationSlide.reset();
      gameRef.player.animation?.done();
    }
    if (!joystick.delta.isZero()) {
      if (joystick.delta.y > 0) {
        gameRef.animationJump.reset();
        gameRef.player.animation = gameRef.animationSlide;
        if (gameRef.animationSlide.isLastFrame) {
          gameRef.player.animation = gameRef.no_fire;
        }
      }
      if (joystick.delta.y < 0) {
        gameRef.animationSlide.reset();
        gameRef.player.animation = gameRef.animationJump;
        if (gameRef.animationJump.isLastFrame) {
          gameRef.player.animation = gameRef.no_fire;
        }
      }
      // position.add(Vector2(joystick.relativeDelta.x, 0) * 200 * dt);
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
    playerState = PlayerState.jumping;

    gameRef.player.animation = gameRef.animationKick;
    gameRef.no_fire.reset();
    // gameRef.animationKick.reset();
    // gameRef.animationJump.reset();
    // gameRef.animationSlide.reset();
  }

  void compl() {
    // if (playerState == PlayerState.reverse) {

    //   playerState = PlayerState.stopped2;
    // } else
    if (playerState == PlayerState.jumping) {
      gameRef.no_fire.reset();
      gameRef.animationKick.reset();
      gameRef.animationJump.reset();
      gameRef.animationSlide.reset();

      playerState = PlayerState.stopped1;
    }
  }

  void compl2() {
    // if (playerState == PlayerState.reverse) {

    //   playerState = PlayerState.stopped2;
    // } else
  }
}
