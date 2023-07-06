import '../../common/uuid.dart';
import 'media_model.dart';
import 'parents/model.dart';

class Patient extends Model {
  String id;
  String user_id;
  String first_name;
  String last_name;
  List<Media> images;
  String phone_number;
  String mobile_number;
  String age;
  String gender;
  String weight;
  String height;
  int total_appointments;

  Patient(
      {this.id,
      this.user_id,
      this.first_name,
      this.last_name,
      this.images,
      this.phone_number,
      this.mobile_number,
      this.age,
      this.gender,
      this.weight,
      this.height,
      this.total_appointments
});

  Patient.fromJson(Map<String, dynamic> json) {
    user_id = stringFromJson(json, 'user_id');
    first_name = transStringFromJson(json, 'first_name');
    last_name = transStringFromJson(json, 'last_name');
    images = mediaListFromJson(json, 'images');
    phone_number = stringFromJson(json,'phone_number');
    mobile_number = stringFromJson(json,'mobile_number');
    age = stringFromJson(json,'age');
    gender = stringFromJson(json,'gender');
    weight = stringFromJson(json,'weight');
    height = stringFromJson(json,'height');
    total_appointments = intFromJson(json,'total_appointments');

    super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (user_id != null) data['user_id'] = this.user_id;
    if (first_name != null) data['first_name'] = this.first_name;
    if (last_name != null) data['last_name'] = this.last_name;
    if (this.images != null) {
      data['image'] = this.images.where((element) => Uuid.isUuid(element.id)).map((v) => v.id).toList();
    }
    if (this.phone_number != null) data['phone_number'] = this.phone_number;
    if (this.mobile_number != null) data['mobile_number'] = this.mobile_number;
    if (this.age != null) data['age'] = this.age;
    if (this.gender != null) data['gender'] = this.gender;
    if (this.weight != null) data['weight'] = this.weight;
    if (this.height != null) data['height'] = this.height;
    if (this.total_appointments != null) data['totalAppointments'] = this.total_appointments;
    return data;
  }

  String get firstImageUrl => this.images?.first?.url ?? '';

  String get firstImageThumb => this.images?.first?.thumb ?? '';

  String get firstImageIcon => this.images?.first?.icon ?? '';


  @override
  bool get hasData {
    return id != null && first_name != null && last_name != null;
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Patient &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          user_id == other.user_id &&
          first_name == other.first_name &&
          last_name == other.last_name &&
          phone_number == other.phone_number &&
          mobile_number == other.mobile_number &&
          age == other.age &&
          gender == other.gender &&
          weight == other.weight &&
          height == other.height &&
          total_appointments == other.total_appointments ;


  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      user_id.hashCode ^
      first_name.hashCode ^
      last_name.hashCode ^
      phone_number.hashCode ^
      mobile_number.hashCode ^
      age.hashCode ^
      gender.hashCode ^
      weight.hashCode ^
      height.hashCode ^
      total_appointments.hashCode ;
}
