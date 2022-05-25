// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.email,
    required this.pharmacyName,
    required this.pharmacyCode,
  });

  String id;
  String firstName;
  String lastName;
  int mobileNumber;
  String email;
  String pharmacyName;
  String pharmacyCode;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobileNumber: json["mobileNumber"],
        email: json["email"],
        pharmacyName: json["pharmacyName"],
        pharmacyCode: json["pharmacyCode"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "mobileNumber": mobileNumber,
        "email": email,
        "pharmacyName": pharmacyName,
        "pharmacyCode": pharmacyCode,
      };
}
