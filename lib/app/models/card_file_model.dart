/*
 * Copyright (c) 2020 .
 */

import 'package:get/get.dart';

import '../services/global_service.dart';
import 'parents/model.dart';

class CardFile extends Model {
  String id;
  String name;
  String url;
  String size;

  CardFile({String id, String url, String thumb, String icon}) {
    this.id = id ?? "";
    this.url = url ?? "${Get.find<GlobalService>().baseUrl}images/file_default.png";
  }

  CardFile.fromJson(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      url = jsonMap['url'];
      size = jsonMap['formatted_size'];
    } catch (e) {
      url = "${Get.find<GlobalService>().baseUrl}images/file_default.png";
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["url"] = url;
    map["formatted_size"] = size;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CardFile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          url == other.url &&
          size == other.size;

  @override
  int get hashCode => super.hashCode ^ id.hashCode ^ name.hashCode ^ url.hashCode ^ size.hashCode;
}
