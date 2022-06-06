// class UserModel {
//   String? email;
//   String? role;
//   String? uid;
//   String? name;
//   String? mobile;
//   String? operationalcenterid;
//   bool? driveroccupied;
//   String? address;
//
// // receiving data
//   UserModel(
//       {this.uid, this.email, this.role, this.name, this.driveroccupied, this.operationalcenterid, this.mobile, this.address});
//   factory UserModel.fromMap(map) {
//     return UserModel(
//       uid: map['uid'],
//       email: map['email'],
//       role: map['role'],
//       name: map['name'],
//       mobile: map['mobile'],
//       address: map['address'],
//       driveroccupied: map['driveroccupied'],
//       operationalcenterid: map['operationalcenterid'],
//     );
//   }
// // sending data
//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'email': email,
//       'role': role,
//       'name': name,
//       'mobile': mobile,
//       'address': address,
//       'driveroccupied': driveroccupied,
//       'operationalcenterid': operationalcenterid,
//     };
//   }
// }
class UserModel {
  String? email;
  String? role;
  String? uid;
  String? name;
  String? mobile;
  String? operationalcenterid;
  bool? driveroccupied;
  String? address;
  String? status;

// receiving data
  UserModel(
      {this.uid,
      this.email,
      this.role,
      this.name,
      this.driveroccupied,
      this.operationalcenterid,
      this.mobile,
      this.address,
      this.status});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      name: map['name'],
      mobile: map['mobile'],
      address: map['address'],
      driveroccupied: map['driveroccupied'],
      operationalcenterid: map['operationalcenterid'],
      status: map['status'],
    );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
      'mobile': mobile,
      'address': address,
      'driveroccupied': driveroccupied,
      'operationalcenterid': operationalcenterid,
      'status': status,
    };
  }

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'],
        email: json['email'],
        role: json['role'],
        name: json['name'],
        mobile: json['mobile'],
        address: json['address'],
        driveroccupied: json['driveroccupied'],
        operationalcenterid: json['operationalcenterid'],
        status: json['status'],
      );
}
