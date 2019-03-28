import 'package:automationCorePrototype/automation/core.dart';
import 'package:automationCorePrototype/automation/lights/hueBasicLightState.dart';
import 'package:automationCorePrototype/automation/types/source.dart';
import 'package:mqtt_client/mqtt_client.dart';

typedef void SubscriptionHandler(String sourceMajor, String sourceMinor, String eventPayload);

class MQTTProvider {
  MqttClient client;
  SubscriptionHandler subscriptionHandler;

  void init(String brokerAddress) {
    client = MqttClient(brokerAddress, 'b968b7fd-559f-4805-8233-827c267c8c3f');
    client.onConnected = this._onConnected;
  }

  void _onConnected() {
    this._addSubscriptions();
    this._addListeners();
  }

  void _addSubscriptions() {
    client.subscribe("source/+/+", MqttQos.exactlyOnce);
  }

  void _addListeners() {

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('::DEBUG::SUB:\n\ttopic:\t<${c[0].topic}>\n\tpayload:\t<$pt>\n::/DEBUG::');

      var originalTopic = c[0].topic;
      var topicParts = originalTopic.split("/");
      String sourceMajor = topicParts[1];
      String sourceMinor = topicParts[2];
      this.subscriptionHandler(sourceMajor, sourceMinor, pt);
    });

  }

  void publishMessage(String deviceType, String deviceID, String messageBody) {
    var topic = "sink/$deviceType/$deviceID";
    print('::DEBUG::PUB:\n\tT:\t<$topic>\n\P:\t<$messageBody>\n::/DEBUG::');
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(messageBody);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload, retain: false);
  }

  void setSubscriptionHandler(SubscriptionHandler subscriptionHandler) {
    this.subscriptionHandler = subscriptionHandler;
  }

  void connect() async {
    await client.connect();
  }
}
