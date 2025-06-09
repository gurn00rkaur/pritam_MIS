class UsersModel {
  String id;
  String name;
  String email;
  String address;
  String city;
  String state;
  String pincode;
  String gstIn;
  String imageUrl;

  UsersModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.gstIn,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'gstIn': gstIn,
      'imageUrl': imageUrl,
    };
  }

  factory UsersModel.fromMap(Map<String, dynamic> map, String id) {
    return UsersModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
      gstIn: map['gstIn'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
