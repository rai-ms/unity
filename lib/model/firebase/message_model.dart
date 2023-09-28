class MessageModel {
  String message;
  String? img;
  String senderUID;
  String time;
  String receiverUID;

  /// [isForwarded] == 1 ? It marked as forwarded
  /// [isForwarded] == 0 ? It marked as normal message
  int isForwarded;

  /// if [visibleNo] == 0? message won't be visible to anyone,
  /// if [visibleNo] == 1? message will only be visible to receiver only
  /// if [visibleNo] == 2? message will only be visible to sender only
  /// if [visibleNo] == 3? message will be visible to everyone
  int visibleNo;
  String chatID;
  String status;
  int deliveryStatus;
  int star;

  /// This is the model of every message
  MessageModel({
    required this.message,
    this.img,
    required this.senderUID,
    required this.time,
    required this.receiverUID,
    this.isForwarded = 0,
    this.visibleNo = 3,
    this.star = 0,
    required this.chatID,
    required this.status,
    this.deliveryStatus = 0,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'],
      img: json['img'],
      senderUID: json['senderUID'],
      time: json['time'],
      receiverUID: json['receiverUID'],
      isForwarded: json['isForwarded'] ?? 0,
      visibleNo: json['visibleNo'] ?? 3,
      chatID: json['chatID'],
      status: json['status'],
      deliveryStatus: json['deliveryStatus'],
      star:json['star'] ?? 0
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'img': img,
      'senderUID': senderUID,
      'time': time,
      'receiverUID': receiverUID,
      'isForwarded': isForwarded,
      'visibleNo': visibleNo,
      'chatID': chatID,
      'status': status,
      'deliveryStatus': deliveryStatus,
      'star':star
    };
  }
}
