import 'package:flutter/material.dart';

import 'clinic_model.dart';
import 'doctor_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class Slide extends Model {
  int order;
  String text;
  String button;
  String textPosition;
  Color textColor;
  Color buttonColor;
  Color backgroundColor;
  Color indicatorColor;
  Media image;
  String imageFit;
  Doctor doctor;
  Clinic clinic;
  bool enabled;

  Slide({
    this.order,
    this.text,
    this.button,
    this.textPosition,
    this.textColor,
    this.buttonColor,
    this.backgroundColor,
    this.indicatorColor,
    this.image,
    this.imageFit,
    this.doctor,
    this.clinic,
    this.enabled,
  });

  Slide.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    order = intFromJson(json, 'order');
    text = transStringFromJson(json, 'text');
    button = transStringFromJson(json, 'button');
    textPosition = stringFromJson(json, 'text_position');
    textColor = colorFromJson(json, 'text_color');
    buttonColor = colorFromJson(json, 'button_color');
    backgroundColor = colorFromJson(json, 'background_color');
    indicatorColor = colorFromJson(json, 'indicator_color');
    image = mediaFromJson(json, 'image');
    imageFit = stringFromJson(json, 'image_fit');
    doctor = json['doctor_id'] != null ? Doctor(id: json['doctor_id'].toString()) : null;
    clinic = json['clinic_id'] != null ? Clinic(id: json['clinic_id'].toString()) : null;
    enabled = boolFromJson(json, 'enabled');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }
}
