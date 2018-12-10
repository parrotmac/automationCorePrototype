
import 'package:automationCorePrototype/automation/mqtt.dart';
import 'package:automationCorePrototype/automation/types/source.dart';

class MQTTAdapter {
  MQTTProvider provider;
  MQTTAdapter(MQTTProvider provider) {
    this.provider = provider;
  }

  bool sendPayload(SourceIdentifier sourceID, String payload) {
    print("Totally sending \"$payload\" via ${sourceID.sourceType}/${sourceID.sourceIdentifier}");
    return false;
  }
}
