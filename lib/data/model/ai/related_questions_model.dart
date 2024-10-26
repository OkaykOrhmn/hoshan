class RelatedQuestionsModel {
  List<String>? questions;

  RelatedQuestionsModel({this.questions});

  RelatedQuestionsModel.fromJson(Map<String, dynamic> json) {
    questions = json['questions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questions'] = questions;
    return data;
  }
}
