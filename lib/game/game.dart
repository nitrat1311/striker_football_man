import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:strikerFootballman/const/colors.dart';
import 'package:strikerFootballman/game/ally.dart';
import 'package:strikerFootballman/game/ally_manager.dart';
import 'package:strikerFootballman/game/records/bloc/records_bloc.dart';
import 'package:strikerFootballman/game/background.dart';

import '../widgets/overlays/pause_menu.dart';
import '../widgets/overlays/pause_button.dart';
import '../widgets/overlays/game_over_menu.dart';

import 'enemy.dart';
import 'health_bar.dart';
import 'player.dart';
import 'command.dart';
import 'enemy_manager.dart';
import 'audio_player_component.dart';

// This class is responsible for initializing and running the game-loop.
class MasksweirdGame extends FlameGame
    with
        HasDraggables,
        HasTappables,
        HasCollisionDetection,
        HasKeyboardHandlerComponents {
  MasksweirdGame({
    required this.recordsBloc,
  });
  // Stores a reference to player component.
  late Player player;
  final RecordsBloc recordsBloc;
  // Stores a reference to the main spritesheet.
  // late SpriteSheet spriteSheet;
  late Sprite sprite;
  late SpriteAnimation no_fire;
  late SpriteAnimation fire;
  late SpriteAnimation animationBack;
  late SpriteAnimation animationForward;
  late SpriteAnimation animationRight;
  late SpriteAnimation animation5;

  // Stores a reference to an enemy manager component.
  late EnemyManager _enemyManager;
  // late AllyManager _allyManager;

  // Displays player score on top left.
  late TextComponent _playerScore;
  late TextComponent _playerScore2;

  // Displays player helth on top right.
  late TextComponent _playerHealth;
  late TextComponent _playerHealth2;
  late PositionComponent _healthBar;

  late final Background _background;

  late AudioPlayerComponent _audioPlayerComponent;

  // List of commands to be processed in current update.
  final _commandList = List<Command>.empty(growable: true);

  // List of commands to be processed in next update.
  final _addLaterCommandList = List<Command>.empty(growable: true);

  // Indicates wheater the game world has been already initilized.
  bool _isAlreadyLoaded = false;

  // This method gets called by Flame before the game-loop begins.
  // Assets loading and adding component should be done here.
  @override
  Future<void> onLoad() async {
    // Makes the game use a fixed resolution irrespective of the windows size.
    camera.viewport = FixedResolutionViewport(Vector2(540, 960));

    // Initilize the game world only one time.
    if (!_isAlreadyLoaded) {
      // Loads and caches all the images for later use.
      await images.loadAll([
        'ship_A.png',
        'animation_fire.png',
        'animation_right.png',
        'animation_forward.png',
        'animation_back.png',
      ]);

      _audioPlayerComponent = AudioPlayerComponent();
      add(_audioPlayerComponent);

      _background = Background();
      await add(_background);
      // sprite = Sprite(
      //   images.fromCache('ally.png'),
      // );

      // final stars = await ParallaxComponent.load(
      //   [ParallaxImageData('stars1.png'), ParallaxImageData('stars2.png')],
      //   fill: LayerFill.width,
      //   repeat: ImageRepeat.repeat,
      //   baseVelocity: Vector2(0, -50),
      //   velocityMultiplierDelta: Vector2(0, 1.5),
      // );
      // add(stars);

      // spriteSheet = SpriteSheet.fromColumnsAndRows(
      //   image: images.fromCache('Group 20.png'),
      //   columns: 8,
      //   rows: 1,
      // );
      no_fire = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('animation_right.png'),
        columns: 4,
        rows: 1,
      ).createAnimation(from: 0, to: 1, row: 0, stepTime: 0.2, loop: false);
      animationBack = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('animation_back.png'),
        columns: 3,
        rows: 1,
      ).createAnimation(from: 0, to: 3, row: 0, stepTime: 0.2, loop: true);
      animationForward = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('animation_forward.png'),
        columns: 3,
        rows: 1,
      ).createAnimation(from: 0, to: 3, row: 0, stepTime: 0.2, loop: true);
      animationRight = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('animation_right.png'),
        columns: 4,
        rows: 1,
      ).createAnimation(from: 0, to: 4, row: 0, stepTime: 0.08, loop: false);
      fire = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('animation_fire.png'),
        columns: 6,
        rows: 1,
      ).createAnimation(from: 0, to: 5, row: 0, stepTime: 0.25, loop: true);
      // Create a basic joystick component on left.
      final joystick = JoystickComponent(
        anchor: Anchor.bottomLeft,
        position: Vector2(size.x / 2 - size.x / 3, size.y - 32),
        background: CircleComponent(
          radius: 50,
          paint: Paint()..color = AppColors.gradientTitle2.withOpacity(0.5),
        ),
        knob: CircleComponent(radius: 30),
      );
      add(joystick);
      player = Player(
        joystick: joystick,
        animation: no_fire,
        size: Vector2(179 / 2, 250 / 2),
        position: Vector2(0, size.y / 1.9),
      );

      // Makes sure that the sprite is centered.
      player.anchor = Anchor.center;
      add(player);
      _healthBar =
          HealthBar(player: player, position: Vector2(size.x - 150, 55));
      add(_healthBar);
      _enemyManager = EnemyManager(spriteSheet: fire);
      // _allyManager = AllyManager(sprite: sprite);
      // add(_allyManager);
      add(_enemyManager);
      final button = ButtonComponent(
        button: CircleComponent(
          radius: 60,
          paint: Paint()..color = AppColors.gradientTitle2.withOpacity(0.5),
        ),
        anchor: Anchor.bottomRight,
        position: Vector2(size.x - 30, size.y - 30),
        onPressed: player.jump,
      );
      add(button);
      // Create text component for player score.
      _playerScore = TextComponent(
        position: Vector2(size.x / 2 - 150, 30),
        textRenderer: TextPaint(
          style: const TextStyle(
              letterSpacing: 5,
              fontFamily: 'LibreBaskerville',
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.normal),
        ),
      );
      _playerScore2 = TextComponent(
        position: Vector2(size.x / 2 - 150, 28),
        textRenderer: TextPaint(
            style: TextStyle(
                letterSpacing: 5,
                fontFamily: 'LibreBaskerville',
                fontSize: 22,
                fontStyle: FontStyle.normal,
                foreground: Paint()
                  ..style = PaintingStyle.fill
                  ..strokeWidth = 1
                  ..color = AppColors.gradientTitle2,
                fontWeight: FontWeight.normal)),
      );
      // Setting positionType to viewport makes sure that this component
      // does not get affected by camera's transformations.
      _playerScore.positionType = PositionType.viewport;
      _playerScore2.positionType = PositionType.viewport;
      _healthBar.positionType = PositionType.viewport;

      add(_playerScore);
      add(_playerScore2);

      // Create text component for player health.
      _playerHealth = TextComponent(
        position: Vector2(size.x - 48, 30),
        textRenderer: TextPaint(
          style: const TextStyle(
              letterSpacing: 5,
              fontFamily: 'LibreBaskerville',
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.normal),
        ),
      );
      _playerHealth2 = TextComponent(
        position: Vector2(size.x - 50, 28),
        textRenderer: TextPaint(
          style: TextStyle(
              letterSpacing: 5,
              fontFamily: 'LibreBaskerville',
              fontSize: 22,
              foreground: Paint()
                ..style = PaintingStyle.fill
                ..strokeWidth = 1
                ..color = AppColors.gradientTitle2,
              fontWeight: FontWeight.normal),
        ),
      );

      // Anchor to top right as we want the top right
      // corner of this component to be at a specific position.
      _playerHealth.anchor = Anchor.topRight;
      _playerHealth2.anchor = Anchor.topRight;
      _healthBar.anchor = Anchor.center;

      // // Setting positionType to viewport makes sure that this component
      // // does not get affected by camera's transformations.
      _playerHealth.positionType = PositionType.viewport;
      _playerHealth2.positionType = PositionType.viewport;

      add(_playerHealth);
      add(_playerHealth2);

      // Set this to true so that we do not initilize
      // everything again in the same session.
      _isAlreadyLoaded = true;
    }
  }

  // This method gets called when game instance gets attached
  // to Flutter's widget tree.
  @override
  void onAttach() {
    if (buildContext != null) {
      // Get the PlayerData from current build context without registering a listener.
      // final playerData = Provider.of<PlayerData>(buildContext!, listen: false);
      // Update the current spaceship type of player.
      // _player.setSpaceshipType(playerData.spaceshipType);
    }
    _audioPlayerComponent.playBgm('music.mp3');
    super.onAttach();
  }

  @override
  void onDetach() {
    _audioPlayerComponent.stopBgm();
    super.onDetach();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // if (_player.health < 80 && _player.health > 40) {
    //   _player.animation = animation2;
    // }

    if (animationRight.isLastFrame) {
      player.compl();
    }
    for (var command in _commandList) {
      for (var component in children) {
        command.run(component);
      }
    }

    // Remove all the commands that are processed and
    // add all new commands to be processed in next update.
    _commandList.clear();
    _commandList.addAll(_addLaterCommandList);
    _addLaterCommandList.clear();

    if (player.isMounted) {
      // Update score and health components with latest values.
      _playerScore.text = 'Score: ${player.score}';
      _playerScore2.text = 'Score: ${player.score}';
      _playerHealth.text = 'Health';
      _playerHealth2.text = 'Health';

      /// Display [GameOverMenu] when [Player.health] becomes
      /// zero and camera stops shaking.
      if (player.health <= 0 && (!camera.shaking)) {
        // _audioPlayerComponent.playSfx('audio/game_over.mp3');
        pauseEngine();
        overlays.remove(PauseButton.id);
        overlays.add(GameOverMenu.id);
      }
    }
  }

  // This method handles state of app and pauses
  // the game when necessary.
  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (player.health > 0) {
          pauseEngine();
          overlays.remove(PauseButton.id);
          overlays.add(PauseMenu.id);
        }
        break;
    }

    super.lifecycleStateChange(state);
  }

  // Adds given command to command list.
  void addCommand(Command command) {
    _addLaterCommandList.add(command);
  }

  // Resets the game to inital state. Should be called
  // while restarting and exiting the game.
  void reset() {
    // First reset player, enemy manager and power-up manager .
    recordsBloc.saveRecord(player.score);
    player.reset();
    _enemyManager.reset();
    // _allyManager.reset();
    player.animation = no_fire;
    children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });
  }

  void resetAlly() {
    children.whereType<Ally>().forEach((ally) {
      ally.removeFromParent();
    });
    // _allyManager.reset();
  }
}
