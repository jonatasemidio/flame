import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:meta/meta.dart';

/// Makes a component capable of notify listeners of changes.
///
/// Notifieable components will automatically notify when
/// new instances are added or removed to the game instance.
///
/// To notify internal changes of a component instance, the component
/// should call [notifyChanges].
mixin Notifiable on Component {
  FlameGame get _gameRef {
    final game = findGame();
    assert(
      game == null || game is FlameGame,
      "Notifiable can't be used without FlameGame",
    );
    return game! as FlameGame;
  }

  @override
  @mustCallSuper
  void onMount() {
    super.onMount();

    _gameRef.notifiers[runtimeType]?.add(this);
  }

  @override
  @mustCallSuper
  void onRemove() {
    _gameRef.notifiers[runtimeType]?.remove(this);

    super.onRemove();
  }

  /// When called, will notify listeners that a change happened on
  /// this component's class notifier.
  void notifyChanges() {
    _gameRef.notifiers[runtimeType]?.notify();
  }
}
