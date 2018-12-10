import 'package:automationCorePrototype/automation/lights/hueBasicLightState.dart';
import 'package:automationCorePrototype/automation/types/lights.dart';
import 'package:automationCorePrototype/automation/types/mqttAdapter.dart';
import 'package:automationCorePrototype/automation/types/source.dart';

class HueBasicLight implements BasicLight, DimmingFadeLight, DimmingLight {
  @override
  String identifier;
  MQTTAdapter adapter;

  int brightnessPercent;
  int transitionTime;

  HueBasicLight(String identifier, MQTTAdapter adapter) {
    this.identifier = identifier;
    this.adapter = adapter;
  }

  String buildStatePayload() {
    HueBasicLightState state = new HueBasicLightState();
    state.on = this.brightnessPercent > 0;
    state.brightness = this.brightnessPercent;
    state.transitionTime = this.transitionTime;

    var data = state.toJson();
    return data.toString();
  }

  void dispatchUpdate() {
    var updateMessage = buildStatePayload();
    this.adapter.sendPayload(new SourceIdentifier("HUE_LIGHT", this.identifier), updateMessage);
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
    print("Turning light " + (on?"ON":"OFF"));
    this.brightnessPercent = on ? 100 : 0;
    this.dispatchUpdate();
  }
}