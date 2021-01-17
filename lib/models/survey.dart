import 'dart:ffi';

class Survey {
  String name;
  String email;
  String phoneNumber;
  String address;
  String location;
  String remarks;
  String latitude;
  String longitude;

  Survey({this.name, this.email, this.phoneNumber, this.address,
      this.location, this.remarks, this.latitude, this.longitude});



  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'location': location,
      'remarks': remarks,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  factory Survey.fromMap(Map<String, dynamic> value) => Survey(
    name:value['name'],
    email:value['email'],
    phoneNumber:value['phone_number'],
    address:value['address'],
    location:value['location'],
    remarks:value['remarks'],
    latitude:value['latitude'],
    longitude:value['longitude']
  );
}
