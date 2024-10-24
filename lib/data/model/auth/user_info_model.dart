class UserInfoModel {
  String? mobileNumber;
  String? name;
  String? image;
  String? email;
  String? username;

  UserInfoModel(
      {this.mobileNumber, this.name, this.image, this.email, this.username});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobile_number'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile_number'] = mobileNumber;
    data['name'] = name;
    data['image'] = image;
    data['email'] = email;
    data['username'] = username;
    return data;
  }

  UserInfoModel copyWith(
      {String? mobileNumber,
      String? name,
      String? image,
      String? email,
      String? username}) {
    return UserInfoModel(
      mobileNumber: mobileNumber ?? this.mobileNumber,
      name: name ?? this.name,
      image: image ?? this.image,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }
}
