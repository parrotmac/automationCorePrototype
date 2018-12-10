
import 'package:automationCorePrototype/automation/types/lights.dart';

class ServoLight implements BasicLight {
  @override
  String identifier;

  @override
  void setOn(bool on) {
    print("Totally telling servo $identifier to turn " + (on ? "on": "off"));
  }
}
