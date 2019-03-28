import 'package:automationCorePrototype/automation/core.dart';

typedef void EventHandler(AutomationCore core, String payload);

class SourceToken {
  SourceToken(String majorIdentifier, String minorIdentifier) {
    if (majorIdentifier.contains("/") || minorIdentifier.contains("/")) {
      throw("Neither majorIdentifier nor minorIdentifier are permitted to contain"
          " a forward slash (/)");
    }
    this.majorIdentifier = majorIdentifier;
    this.minorIdentifier = minorIdentifier;
  }
  String majorIdentifier;
  String minorIdentifier;

  bool equalsValues(String majorValue, String minorValue) {
    return this.majorIdentifier == majorValue && this.minorIdentifier == minorValue;
  }

  @override
  String toString() {
    return "$majorIdentifier/$minorIdentifier";
  }
}

abstract class Source {
  SourceToken _sourceToken;

  void handleMatchingEvent(String eventBody, AutomationCore core) {
    // To be implemented by subclass
    print(eventBody);
  }

  void setSourceToken(String majorIdentifier, String sourceID) {
    this._sourceToken = new SourceToken(majorIdentifier, sourceID);
  }

  SourceToken getSourceToken() {
    return this._sourceToken;
  }

  EventHandler handleEvent(String eventPayload, AutomationCore core) {}
}
