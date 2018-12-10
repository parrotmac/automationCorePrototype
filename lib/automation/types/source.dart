import 'package:automationCorePrototype/automation/core.dart';

typedef Function EventHandler(AutomationCore core, String payload);

class SourceIdentifier {
  SourceIdentifier(String sourceType, String sourceIdentifier) {
    this.sourceType = sourceType;
    this.sourceIdentifier = sourceIdentifier;
  }
  String sourceType;
  String sourceIdentifier;

  @override
  String toString() {
    return "$sourceType/$sourceIdentifier";
  }
}

abstract class Source {
  String identifier;
  EventHandler eventHandler;
  SourceIdentifier getSubscriptionDeviceType() {
    return new SourceIdentifier("+", "+");
  }
}
