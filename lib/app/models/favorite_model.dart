import 'doctor_model.dart';
import 'option_model.dart';
import 'parents/model.dart';

class Favorite extends Model {
  String id;
  Doctor doctor;
  String userId;

  Favorite({this.id, this.doctor, this.userId});

  Favorite.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    doctor = objectFromJson(json, 'doctor', (v) => Doctor.fromJson(v));
    userId = stringFromJson(json, 'user_id');
  }

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["doctor_id"] = doctor.id;
    map["user_id"] = userId;
    return map;
  }
}
