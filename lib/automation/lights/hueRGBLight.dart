import 'package:automationCorePrototype/automation/types/lights.dart';
import 'package:automationCorePrototype/automation/types/mqttAdapter.dart';

class HueRGBLight implements BasicLight, DimmingLight, DimmingFadeLight, DimmingRGBLight, DimmingFadeRGBLight {
  String identifier;
  MQTTAdapter _mqttAdapter;

  HueRGBLight(String identifier, MQTTAdapter adapter) {
    this.identifier = identifier;
    this._mqttAdapter = adapter;
  }

  @override
  void setBrightness(int percent) {
    // TODO: implement setBrightness
  }

  @override
  void setBrightnessWithFade(int percent, int fadeMilliseconds) {
    // TODO: implement setBrightnessWithFade
  }

  @override
  void setOn(bool on) {
    // TODO: implement setOn
  }

  @override
  void setRGB(LightColor lightColor) {
    // TODO: implement setRGB
  }

  @override
  void setRGBWithFade(LightColor lightColor, int fadeMilliseconds) {
    // TODO: implement setRGBWithFade
  }

}
