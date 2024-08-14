import 'package:firebase_auth/firebase_auth.dart';

class User {
  String? fullName ;
  String? email;
  String? mobileNo;
  String? address;
  String? gender;
  String? emergencyNo;

  // Constructor
  User({
    required this.fullName,
    required this.email,
    required this.mobileNo,
    required this.address,
    required this.gender,
    required this.emergencyNo,
  });

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName']?? "" ;
    email = json['email']?? "";
    mobileNo = json['mobileNo']??"";
    address = json['address']?? "" ;
    gender = json['gender']?? "" ;
    emergencyNo = json['emergencyNo']?? "";
  }



  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'mobileNo': mobileNo,
      'address': address,
      'gender': gender,
      'emergencyNo': emergencyNo,
    };
  }
}
