import 'package:automationCorePrototype/automation/deviceAction.dart';
import 'package:automationCorePrototype/automation/lights/hueBasicLight.dart';
import 'package:automationCorePrototype/automation/lights/hueRGBLight.dart';
import 'package:automationCorePrototype/automation/lights/servoLight.dart';
import 'package:automationCorePrototype/automation/mqtt.dart';
import 'package:automationCorePrototype/automation/sources/hueSwitch.dart';
import 'package:automationCorePrototype/automation/types/mqttAdapter.dart';
import 'package:automationCorePrototype/automation/types/source.dart';

class AutomationCore {
  List<DeviceAction> _pendingActions;

  Map<SourceToken, Source> sources = {};

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

  void dispatchSourceActionFromIncomingMessage(String sourceMajor, String sourceMinor, String eventPayload) {
    this.sources.forEach((SourceToken token, Source source) {
      if(token.equalsValues(sourceMajor, sourceMinor)) {
        source.handleEvent(eventPayload, this);
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
    this.sources[newSource.getSourceToken()] = newSource;
  }

  void performFakeAttachments() {
    var hueMQTTAdapter = new MQTTAdapter(this.mqttProvider);

    var bathroomLight1 = new HueBasicLight("1", hueMQTTAdapter);
    this.hueBasicLights["BATHROOM/LIGHT/1"] = bathroomLight1;

    var bathroomLight2 = new HueBasicLight("2", hueMQTTAdapter);
    this.hueBasicLights["BATHROOM/LIGHT/2"] = bathroomLight2;

    var bathroomLight3 = new HueBasicLight("4", hueMQTTAdapter);
    this.hueBasicLights["BATHROOM/LIGHT/3"] = bathroomLight3;

    var bedroomSwitch = new HueSwitch("1");
    bedroomSwitch.attachEventHandler(ButtonPress(HUE_BUTTON.TOP, HUE_PRESS_TYPE.SHORT_DN), (ButtonPress press) {
      print("Top button for bedroom pressed");
    });
    bedroomSwitch.attachEventHandler(ButtonPress(HUE_BUTTON.TOP, HUE_PRESS_TYPE.LONG_DN), (ButtonPress press) {
      turnAllLightsOn();
    });
    bedroomSwitch.attachEventHandler(ButtonPress(HUE_BUTTON.BTM, HUE_PRESS_TYPE.LONG_DN), (ButtonPress press) {
      turnAllLightsOff();
    });

    var mainRoomSwitch = new HueSwitch("2");
    mainRoomSwitch.attachEventHandler(ButtonPress(HUE_BUTTON.TOP, HUE_PRESS_TYPE.SHORT_DN), (ButtonPress press) {
      print("Top button for main room pressed");
    });
    mainRoomSwitch.attachEventHandler(ButtonPress(HUE_BUTTON.TOP, HUE_PRESS_TYPE.LONG_DN), (ButtonPress press) {
      turnAllLightsOn();
    });
    mainRoomSwitch.attachEventHandler(ButtonPress(HUE_BUTTON.BTM, HUE_PRESS_TYPE.LONG_DN), (ButtonPress press) {
      turnAllLightsOff();
    });


    var bathroomSwitch = new HueSwitch("3");

    var bathroomSwitchPressState = 0;

    var turnOnNightlight = () {
      bathroomLight3.setOn(false);
      bathroomLight2.setBrightnessWithFade(1, 900);
      bathroomLight1.setOn(false);
    };

    var turnOnFullBrightness = () {
      bathroomLight3.setBrightnessWithFade(100, 200);
      bathroomLight2.setBrightnessWithFade(100, 200);
      bathroomLight1.setBrightnessWithFade(100, 200);
    };

    bathroomSwitch.attachEventHandler(ButtonPress(HUE_BUTTON.TOP, HUE_PRESS_TYPE.LONG_DN), (ButtonPress press) {
      turnAllLightsOn();
    });
    bathroomSwitch.attachEventHandler(ButtonPress(HUE_BUTTON.BTM, HUE_PRESS_TYPE.LONG_DN), (ButtonPress press) {
      turnAllLightsOff();
    });

    bathroomSwitch.attachEventHandler(ButtonPress(HUE_BUTTON.TOP, HUE_PRESS_TYPE.SHORT_DN), (ButtonPress press) {
      switch(bathroomSwitchPressState) {
        case 0:
          turnOnNightlight();
          break;
        case 1:
          turnOnFullBrightness();
          break;
      }

      if (bathroomSwitchPressState >= 1) {
        bathroomSwitchPressState = 0;
      } else {
        bathroomSwitchPressState++;
      }
    });

    bathroomSwitch.attachEventHandler(ButtonPress(HUE_BUTTON.BTM, HUE_PRESS_TYPE.SHORT_DN), (ButtonPress press) {
      bathroomSwitchPressState = 0;
      bathroomLight1.setOn(false);
      bathroomLight2.setOn(false);
      bathroomLight3.setOn(false);
    });

    this.registerSource(bedroomSwitch);
    this.registerSource(mainRoomSwitch);
    this.registerSource(bathroomSwitch);
  }

}