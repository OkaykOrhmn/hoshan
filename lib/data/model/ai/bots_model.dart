class BotsModel {
  List<Bots>? bots;

  BotsModel({this.bots});

  BotsModel.fromJson(Map<String, dynamic> json) {
    if (json['bots'] != null) {
      bots = <Bots>[];
      json['bots'].forEach((v) {
        bots!.add(Bots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bots != null) {
      data['bots'] = bots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bots {
  int? id;
  String? name;
  String? image;
  int? attachment;
  List<String>? attachmentType;

  Bots({this.id, this.name, this.image, this.attachment, this.attachmentType});

  Bots.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    attachment = json['attachment'];
    attachmentType = json['attachment_type']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['attachment'] = attachment;
    data['attachment_type'] = attachmentType;
    return data;
  }
}
