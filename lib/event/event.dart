import 'package:event_bus/event_bus.dart';

EventBus bus = EventBus();

class DarkThemeEvent {
  bool darkTheme;

  DarkThemeEvent(this.darkTheme);
}
