import 'dart:convert';

import 'package:automationCorePrototype/automation/lights/hueBasicLightState.dart';
import 'package:automationCorePrototype/automation/types/lights.dart';
import 'package:automationCorePrototype/automation/types/mqttAdapter.dart';
import 'package:automationCorePrototype/automation/types/source.dart';

class HueBasicLight implements BasicLight, DimmingFadeLight, DimmingLight {
  @override
  String identifier;
  MQTTAdapter adapter;

  int brightnessPercent;
  int transitionTime; // 100ms increments (value should be 4 for 400ms)

  HueBasicLight(String hueLightId, MQTTAdapter adapter) {
    this.identifier = hueLightId;
    this.adapter = adapter;
  }

  String buildStatePayload() {
    HueBasicLightState state = new HueBasicLightState();
    state.on = this.brightnessPercent > 0;
    state.brightness = this.brightnessPercent;
    state.transitionTime = this.transitionTime;
    return json.encode(state.toJson());
  }

  void dispatchUpdate() {
    var updateMessage = buildStatePayload();
    // TODO: Revisit -- this looks wrong
    this.adapter.sendPayload(new SourceToken("hue_light", this.identifier), updateMessage);
  }

  @override
  void setBrightness(int percent) {
    this.brightnessPercent = percent;
    this.dispatchUpdate();
  }

  @override
  void setBrightnessWithFade(int percent, int fadeMilliseconds) {
    this.brightnessPercent = percent;
    this.transitionTime = (fadeMilliseconds/100).round();
    this.dispatchUpdate();
  }

  @override
  void setOn(bool on) {
    print("Turning light " + (on?"ON":"OFF"));
    this.brightnessPercent = on ? 100 : 0;
    this.dispatchUpdate();
  }
}