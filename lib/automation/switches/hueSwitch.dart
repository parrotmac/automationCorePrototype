import 'package:automationCorePrototype/automation/types/source.dart';

class HueSwitch extends Source {
  HueSwitch(String identifier, EventHandler eventHandler) {
    this.identifier = identifier;
    this.eventHandler = eventHandler;
  }

  @override
  SourceIdentifier getSubscriptionDeviceType() {
    // This is should match 'Device Type' sent in incoming MQTT topics
    return new SourceIdentifier("HUE_SWITCH", this.identifier);
  }
}
