import 'package:json_annotation/json_annotation.dart';

part 'hueSwitchMessage.g.dart';

/*
Example message
{"switch_id": 3, "button_id": 4, "state_id": 2}
 */

@JsonSerializable(nullable: false)
class HueSwitchMessage {
  @JsonKey(name: "switch_id", nullable: false)
  String switchID;

  @JsonKey(name: "button_id", nullable: false)
  String buttonID;

  @JsonKey(name: "state_id", nullable: false)
  String stateID;

  HueSwitchMessage({this.switchID, this.buttonID, this.stateID});
  factory HueSwitchMessage.fromJson(Map<String, dynamic> json) => _$HueSwitchMessageFromJson(json);
  Map<String, dynamic> toJson() => _$HueSwitchMessageToJson(this);
}
