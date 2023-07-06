import 'package:get/get.dart';

import 'media_model.dart';
import 'parents/model.dart';

class Option extends Model {
  String id;
  String optionGroupId;
  String doctorId;
  String name;
  double price;
  Media image;
  String description;
  var checked = false.obs;

  Option({this.id, this.optionGroupId, this.doctorId, this.name, this.price, this.image, this.description, this.checked});

  Option.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    optionGroupId = stringFromJson(json, 'option_group_id', defaultValue: '0');
    doctorId = stringFromJson(json, 'doctor_id', defaultValue: '0');
    name = transStringFromJson(json, 'name');
    price = doubleFromJson(json, 'price');
    description = transStringFromJson(json, 'description');
    image = mediaFromJson(json, 'image');
  }

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    if (id != null) map["id"] = id;
    if (name != null) map["name"] = name;
    if (price != null) map["price"] = price;
    if (description != null) map["description"] = description;
    if (checked != null) map["checked"] = checked.value;
    if (optionGroupId != null) map["option_group_id"] = optionGroupId;
    if (doctorId != null) map["doctor_id"] = doctorId;
    if (this.image != null) {
      map['image'] = this.image.toJson();
    }
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Option &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          optionGroupId == other.optionGroupId &&
          doctorId == other.doctorId &&
          name == other.name &&
          price == other.price &&
          image == other.image &&
          description == other.description &&
          checked == other.checked;

  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ optionGroupId.hashCode ^ doctorId.hashCode ^ name.hashCode ^ price.hashCode ^ image.hashCode ^ description.hashCode ^ checked.hashCode;
}
