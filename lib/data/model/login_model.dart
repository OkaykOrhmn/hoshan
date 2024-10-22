class LoginModel {
  String? detail;
  String? accessToken;
  String? tokenType;

  LoginModel({this.detail, this.accessToken, this.tokenType});

  LoginModel.fromJson(Map<String, dynamic> json) {
    detail = json['detail'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['detail'] = detail;
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    return data;
  }
}
