class UserProfileModel {
  String name, email, pass, image, uid, joinDate;
  List<String> blockedUID = []; // List of blocked user IDs

  UserProfileModel({
    required this.uid,
    required this.image,
    required this.name,
    required this.email,
    required this.pass,
    required this.joinDate,
    List<String>? blockedUID, // Optional parameter for initializing blockedUID
  }) {
    // Initialize blockedUID with an empty list if not provided
    this.blockedUID = blockedUID ?? [];
  }

  Map<String, dynamic> toMap()
  {
    return <String, dynamic>{
      "id": uid,
      "name": name,
      "pass": pass,
      "image": image,
      "joinDate": joinDate,
      "email": email,
      "blockedUID": blockedUID, // Include the blocked user IDs in the map
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      uid: json['id'],
      name: json['name'],
      pass: json['pass'],
      image: json['image'],
      joinDate: json['joinDate'],
      email: json['email'],
      blockedUID: json['blockedUID'] != null
          ? List<String>.from(json['blockedUID']) // Convert JSON array to a List<String>
          : [], // Initialize with an empty list if not present
    );
  }
}
