import 'parents/model.dart';

class AppointmentStatus extends Model {
  String id;
  String status;
  int order;

  AppointmentStatus({this.id, this.status, this.order});

  AppointmentStatus.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    status = transStringFromJson(json, 'status');
    order = intFromJson(json, 'order');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['order'] = this.order;
    return data;
  }
}
