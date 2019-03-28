
import 'package:automationCorePrototype/automation/mqtt.dart';
import 'package:automationCorePrototype/automation/types/source.dart';

class MQTTAdapter {
  MQTTProvider provider;
  MQTTAdapter(MQTTProvider provider) {
    this.provider = provider;
  }

  bool sendPayload(SourceToken token, String payload) {
    var deviceType = token.majorIdentifier;
    var deviceID = token.minorIdentifier;
    this.provider.publishMessage(deviceType, deviceID, payload);
    print("Totally sending \"$payload\" via $deviceType/$deviceID");
    return false;
  }
}
