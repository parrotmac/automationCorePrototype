import 'dart:convert';

import 'package:automationCorePrototype/automation/core.dart';
import 'package:automationCorePrototype/automation/sources/hueSwitchMessage.dart';
import 'package:automationCorePrototype/automation/types/source.dart';

enum HUE_BUTTON {
  TOP,
  MID_TOP,
  MID_BTM,
  BTM
}

enum HUE_PRESS_TYPE {
  SHORT_DN,
  SHORT_UP,
  LONG_DN,
  LONG_UP
}

class ButtonPress {
  HUE_BUTTON hue_button;
  HUE_PRESS_TYPE hue_press_type;

  // TODO: Idea: pass hueSwitchMessage in to see if it's a match
  bool matchesMessage() {
      return false;
  }

  ButtonPress(HUE_BUTTON button, HUE_PRESS_TYPE pressType) {
    this.hue_button = button;
    this.hue_press_type = pressType;
  }

  String toButtonString() {
    switch(this.hue_button) {
      case HUE_BUTTON.TOP:
        return "1";
      case HUE_BUTTON.MID_TOP:
        return "2";
      case HUE_BUTTON.MID_BTM:
        return "3";
      case HUE_BUTTON.BTM:
        return "4";
    }
  }

  String toPressString() {
    switch(this.hue_press_type) {
      case HUE_PRESS_TYPE.SHORT_DN:
        return "0";
      case HUE_PRESS_TYPE.SHORT_UP:
        return "2";
      case HUE_PRESS_TYPE.LONG_DN:
        return "1";
      case HUE_PRESS_TYPE.LONG_UP:
        return "3";
    }
  }
}

typedef void HueSwitchEventHandler(ButtonPress pressData);

class HueSwitch extends Source {
  Map<ButtonPress, HueSwitchEventHandler> eventHandlers = {};

  HueSwitch(String minorIdentifier) {
    super.setSourceToken("hue_switch", minorIdentifier);
  }

  void attachEventHandler(ButtonPress pressType, HueSwitchEventHandler eventHandler) {
    this.eventHandlers[pressType] = eventHandler;
  }

  void dispatchHandlerFromMessage(String switchID, String buttonID, String stateID) {
    this.eventHandlers.forEach((ButtonPress press, HueSwitchEventHandler handler) {
      if(press.toButtonString() == buttonID && press.toPressString() == stateID) {
        handler(press);
      }
    });
  }

  @override
  EventHandler handleEvent(String payload, AutomationCore core) {
    HueSwitchMessage msg = new HueSwitchMessage.fromJson(json.decode(payload) as Map<String, dynamic>);
    dispatchHandlerFromMessage(msg.stateID, msg.buttonID, msg.stateID);
  }
}
