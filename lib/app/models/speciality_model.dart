import 'package:flutter/material.dart';

import 'doctor_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class Speciality extends Model {
  String id;
  String name;
  String description;
  Color color;
  Media image;
  bool featured;
  List<Speciality> subSpecialities;
  List<Doctor> doctors;

  Speciality({this.id, this.name, this.description, this.color, this.image, this.featured, this.subSpecialities, this.doctors});

  Speciality.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    color = colorFromJson(json, 'color');
    description = transStringFromJson(json, 'description');
    image = mediaFromJson(json, 'image');
    featured = boolFromJson(json, 'featured');
    doctors = listFromJsonArray(json, ['doctors', 'featured_doctors'], (v) => Doctor.fromJson(v));
    subSpecialities = listFromJson(json, 'sub_specialities', (v) => Speciality.fromJson(v));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['color'] = '#${this.color.value.toRadixString(16)}';
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Speciality &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          color == other.color &&
          image == other.image &&
          featured == other.featured &&
          subSpecialities == other.subSpecialities &&
          doctors == other.doctors;

  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ name.hashCode ^ description.hashCode ^ color.hashCode ^ image.hashCode ^ featured.hashCode ^ subSpecialities.hashCode ^ doctors.hashCode;
}
