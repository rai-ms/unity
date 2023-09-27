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

}