
import 'package:automationCorePrototype/automation/types/device.dart';

class LightColor {
  int redPercent;
  int greenPercent;
  int bluePercent;
}

abstract class BasicLight extends Device {
  BasicLight(String identifier) : super(identifier);

  void setOn(bool on) {}
}

abstract class DimmingLight extends Device {
  DimmingLight(String identifier) : super(identifier);

  void setBrightness(int percent) {}
}

abstract class DimmingFadeLight extends Device {
  DimmingFadeLight(String identifier) : super(identifier);

   void setBrightnessWithFade(int percent, int fadeMilliseconds) {}
}

abstract class DimmingRGBLight extends Device {
  DimmingRGBLight(String identifier) : super(identifier);

  void setRGB(LightColor lightColor) {}
}

abstract class DimmingFadeRGBLight extends Device {
  DimmingFadeRGBLight(String identifier) : super(identifier);

  void setRGBWithFade(LightColor lightColor, int fadeMilliseconds) {}
}
