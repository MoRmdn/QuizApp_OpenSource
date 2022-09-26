class QuestionModel {
  String id;
  int answer;
  String correctA;
  String explanation;
  String question;
  String? imageURL;
  List<dynamic> options;

  QuestionModel({
    required this.id,
    required this.answer,
    required this.question,
    required this.correctA,
    required this.explanation,
    required this.options,
    this.imageURL,
  });
}
