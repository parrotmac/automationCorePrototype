import 'package:json_annotation/json_annotation.dart';

part 'hueBasicLightState.g.dart';

@JsonSerializable(nullable: false)

class HueBasicLightState{
  @JsonKey(name: 'on', nullable: false)
  bool on; // on

  @JsonKey(name: 'transitiontime', nullable: true, includeIfNull: false)
  int transitionTime; // transitiontime

  @JsonKey(name: 'bri', nullable: false)
  int brightness; // bri

  HueBasicLightState({this.on, this.transitionTime, this.brightness});
  factory HueBasicLightState.fromJson(Map<String, dynamic> json) => _$HueBasicLightStateFromJson(json);
  Map<String, dynamic> toJson() => _$HueBasicLightStateToJson(this);
}
