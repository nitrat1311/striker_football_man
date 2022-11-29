import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

class Background extends ParallaxComponent {
  @override
  Future<void>? onLoad() async {
    final layers = await Future.wait<ParallaxLayer>([
      backGroundSnow,
    ]);
    parallax = Parallax(
      layers,
      baseVelocity: Vector2(0, 0),
    );

    return super.onLoad();
  }

  Future<ParallaxLayer> get backGroundSnow => gameRef.loadParallaxLayer(
        ParallaxImageData('back.png'),
        fill: LayerFill.width,
        velocityMultiplier: Vector2(0.5, 0.0),
      );

  void changeLayerDay({
    required ParallaxLayer layerBack,
    required ParallaxLayer layerStars,
  }) {
    final Parallax? _parallax = parallax;
    if (_parallax != null) {
      _parallax.layers[0] = layerBack;
      _parallax.layers[1] = layerStars;

      parallax = Parallax(
        _parallax.layers,
        baseVelocity: Vector2(0, 0),
      );
    }
  }
}
