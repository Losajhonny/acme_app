class AnswerModel {
  String quiz = "";
  String uId = "";
  List answers = [];

  Object toObject() {
    var answer = {
      "quiz": quiz,
      "uId": uId,
      "answers": answers
    };
    return answer;
  }
}
