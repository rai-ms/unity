class UserProfileModel
{
  String name, email, pass, image, uid, joinDate;
  UserProfileModel({required this.uid, required this.image, required this.name, required this.email, required this.pass, required this.joinDate});

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      "id":uid,
      "name":name,
      "pass":pass,
      "image":image,
      "joinDate":joinDate,
      "email":email
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
    );
  }


}