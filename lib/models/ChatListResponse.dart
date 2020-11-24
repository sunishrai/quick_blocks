class ChatListResponse {
  int errorCode;
  String message;
  List<Data> data;

  ChatListResponse({this.errorCode, this.message, this.data});

  ChatListResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String chatBy;
  String quickLogin;
  String name;

  Data({this.chatBy, this.quickLogin, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    chatBy = json['chat_by'];
    quickLogin = json['quick_login'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_by'] = this.chatBy;
    data['quick_login'] = this.quickLogin;
    data['name'] = this.name;
    return data;
  }
}