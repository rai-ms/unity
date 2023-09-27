import 'package:unity/data/response/status.dart';

class APIResponse<T> {
  Status? status;
  T? data;
  String? message;

  APIResponse.loading() : status = Status.WAITING;
  APIResponse.error(this.message) : status = Status.ERROR;
  APIResponse.completed(this.data) : status = Status.COMPLETED;

  @override
  String toString() {
    return "Status: $status, Data: $data, Message: $message";
  }
}
