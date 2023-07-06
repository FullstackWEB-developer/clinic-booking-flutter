/*
 * Copyright (c) 2020 .
 */

import 'dart:core';

import 'parents/model.dart';

class ClinicLevel extends Model {
  String id;
  String name;
  double commission;

  ClinicLevel({this.id, this.name, this.commission});

  ClinicLevel.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    commission = doubleFromJson(json, 'commission');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['commission'] = this.commission;
    return data;
  }
}
