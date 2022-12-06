import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:strikerFootballman/game/ally.dart';
import 'package:strikerFootballman/game/command.dart';
import 'package:strikerFootballman/game/game.dart';
import 'package:strikerFootballman/game/player.dart';

import 'enemy.dart';

// This component represent a bullet in game world.
class Bullet extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<MasksweirdGame> {
  // Speed of the bullet.

  Random random = Random();
  // // Controls the direction in which bullet travels.
  Vector2 getRandomVector() {
    return (Vector2.random(random) - Vector2.random(random)) * 500;
  }

  var direction = 1;

  Bullet({
    required SpriteAnimation? animation,
    required Vector2? position,
    required Vector2? size,
  }) : super(animation: animation, position: position, size: size);

  @override
  void onMount() {
    super.onMount();
    // Adding a circular hitbox with radius as 0.4 times
    //  the smallest dimension of this components size.
    final shape = CircleHitbox.relative(
      0.4,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
    gameRef.player.isRunning = true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // If the other Collidable is Enemy, remove this bullet.
    if (other is Ally) {
      // direction =
      //     Vector2(-random.nextDouble() - 0.5, -random.nextDouble() + 0.7);
    }
    if (other is Player) {
      direction = -1;
      // removeFromParent();
      // gameRef.player.animation = gameRef.catch_animation;

      // gameRef.resetAlly();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Moves the bullet to a new position with _speed and direction.
    position += Vector2(-0.4 * direction, -0.5) * 650 * dt;
    // if (position.y < 30 || position.y > gameRef.size.y - 30) {
    //   direction.y = direction.y * -1;
    // }

    if (position.x < 20) {
      gameRef.player.increaseHealthBy(-25);
      gameRef.camera.shake(intensity: 5);
      // gameRef.player.addToScore(10);
      removeFromParent();
      gameRef.player.isRunning = false;
    }
    if (position.x > gameRef.size.x / 2 + 50 &&
        position.y < gameRef.size.y / 2 - 140) {
      removeFromParent();
      gameRef.player.isRunning = false;
      if (position.x < gameRef.size.y / 2 - 156) {
        final particleComponent = ParticleSystemComponent(
          particle: Particle.generate(
            count: 10,
            lifespan: 0.2,
            generator: (i) => AcceleratedParticle(
              acceleration: getRandomVector(),
              speed: getRandomVector(),
              position: position.clone(),
              child: CircleParticle(
                radius: 8,
                paint: Paint()..color = Colors.orange,
              ),
            ),
          ),
        );
        final command = Command<Player>(action: (player) {
          // Use the correct killPoint to increase player's score.

          player.addToScore(30);
        });
        gameRef.addCommand(command);
        gameRef.add(particleComponent);
      } else {
        final particleComponent = ParticleSystemComponent(
          particle: Particle.generate(
            count: 10,
            lifespan: 0.2,
            generator: (i) => AcceleratedParticle(
              acceleration: getRandomVector(),
              speed: getRandomVector(),
              position: position.clone(),
              child: CircleParticle(
                radius: 8,
                paint: Paint()..color = Color.fromARGB(255, 220, 220, 220),
              ),
            ),
          ),
        );
        final command = Command<Player>(action: (player) {
          // Use the correct killPoint to increase player's score.

          player.addToScore(10);
        });
        gameRef.addCommand(command);
        gameRef.add(particleComponent);
      }
    }
    // if (position.y < 0 || position.x > gameRef.size.y) {
    //   gameRef.player.increaseHealthBy(-10);
    //   gameRef.camera.shake(intensity: 5);
    //   removeFromParent();
    // }
  }
}
