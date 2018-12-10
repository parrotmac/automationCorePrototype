import 'package:automationCorePrototype/automation/deviceAction.dart';
import 'package:automationCorePrototype/automation/lights/hueBasicLight.dart';
import 'package:automationCorePrototype/automation/lights/hueRGBLight.dart';
import 'package:automationCorePrototype/automation/lights/servoLight.dart';
import 'package:automationCorePrototype/automation/mqtt.dart';
import 'package:automationCorePrototype/automation/switches/hueSwitch.dart';
import 'package:automationCorePrototype/automation/types/mqttAdapter.dart';
import 'package:automationCorePrototype/automation/types/source.dart';

class AutomationCore {
  List<DeviceAction> _pendingActions;

  Map<SourceIdentifier, Source> sources = {};

  Map<String, HueRGBLight> hueRGBLights = {};
  Map<String, HueBasicLight> hueBasicLights = {};
  Map<String, ServoLight> servoLights = {};

  MQTTProvider mqttProvider;

  void addAction(DeviceAction action) {
    this._pendingActions.add(action);
  }

  void cancelAction(DeviceAction action) {
    this._pendingActions.remove(action);
  }

  DeviceAction getCurrentAction() {
    if (this._pendingActions.length > 0) {
      return this._pendingActions[0];
    }
    return null;
  }


  /* Example Macros */
  void turnAllLightsOn() {
    this.hueRGBLights.forEach((id, light) => light.setOn(true));
    this.hueBasicLights.forEach((id, light) => light.setOn(true));
    this.servoLights.forEach((id, light) => light.setOn(true));
  }

  void turnAllLightsOff() {
    this.hueRGBLights.forEach((id, light) => light.setOn(false));
    this.hueBasicLights.forEach((id, light) => light.setOn(false));
    this.servoLights.forEach((id, light) => light.setOn(false));
  }

  void dispatchSourceActionFromIncomingMessage(SourceIdentifier sourceID, String payload) {
    this.sources.forEach((SourceIdentifier key, Source value) {
      if (key.sourceType == sourceID.sourceType && key.sourceIdentifier == sourceID.sourceIdentifier) {
        value.eventHandler(this, payload);
      }
    });
  }

  AutomationCore() {
    const mqttBrokerAddress = "mqtt.stag9.com";

    this.mqttProvider = new MQTTProvider();
    this.mqttProvider.setSubscriptionHandler(this.dispatchSourceActionFromIncomingMessage);
    this.mqttProvider.init(mqttBrokerAddress);
  }

  void run() {
    this.mqttProvider.connect();
  }

  void registerSource(Source newSource) {
    var sourceID = newSource.getSubscriptionDeviceType();
    this.sources.putIfAbsent(sourceID, () => newSource);
  }

  void performFakeAttachments() {
    var hueMQTTAdapter = new MQTTAdapter(this.mqttProvider);
    var bathroomLightOne = new HueBasicLight("1", hueMQTTAdapter);
    var bathroomLightTwo = new HueBasicLight("3", hueMQTTAdapter);
    var bathroomLightThree = new HueBasicLight("4", hueMQTTAdapter);

    this.hueBasicLights.putIfAbsent("BATHROOM/1", () => bathroomLightOne);
    this.hueBasicLights.putIfAbsent("BATHROOM/2", () => bathroomLightTwo);
    this.hueBasicLights.putIfAbsent("BATHROOM/3", () => bathroomLightThree);

    var bedroomSwitch = new HueSwitch("1", (AutomationCore core, String payload) {
      core.turnAllLightsOn();
    });


    var mainRoomSwitch = new HueSwitch("2", (AutomationCore core, String payload) {
      core.turnAllLightsOff();
    });


    var bathroomSwitch = new HueSwitch("3", (AutomationCore core, String payload) {
      core.turnAllLightsOn();
    });

    this.registerSource(bedroomSwitch);
    this.registerSource(mainRoomSwitch);
    this.registerSource(bathroomSwitch);
  }

}