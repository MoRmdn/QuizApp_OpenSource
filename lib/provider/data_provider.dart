import 'dart:async';
import 'dart:developer';

import 'package:QuizApp/models/question_model.dart';
import 'package:QuizApp/screens/quiz_screen.dart';
import 'package:QuizApp/screens/users_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/result_screen/result_screen.dart';

class QuizController extends GetxController {
  List<QuestionModel> _questionsList = [];

  int get countOfQuestion => _questionsList.length;

  List<QuestionModel> _flagedList = [];

  int get countOfFlaged => _flagedList.length;

  Future<void> fetchTopicData(
    String domainName,
    String topicName,
  ) async {
    final _db =
        FirebaseFirestore.instance.collection('DB').doc('h60FQ93NHwIx4sGvedTY');

    _questionsList = [];
    List<QuestionModel> newList = [];

    try {
      final getTopic = await _db
          .collection(domainName)
          .doc("${domainName}_Path")
          .collection(topicName)
          .get();

      final listOfQuestions = getTopic.docs;
      for (var element in listOfQuestions) {
        List<dynamic> options = element['answers'];
        int correctAnswerIndex = options.indexWhere(
          (option) => option == element['correctAnswer'],
        );
        // log(element['answers'].toString());
        newList.add(
          QuestionModel(
              id: element.id,
              answer: correctAnswerIndex,
              question: element['question'],
              explanation: element['illustration'],
              correctA: element['correctAnswer'],
              options: element['answers'],
              imageURL: element['imageURl'] ?? ''),
        );
      }
      log(newList[0].answer.toString());
      _questionsList = newList;
    } catch (e) {
      log(e.toString());
    }
    update();
  }

  List<QuestionModel> get questionsList => [..._questionsList];

  List<QuestionModel> get flaggedList => [..._flagedList];

  bool _isSubmit = false;

  bool get isSubmit => _isSubmit;

  bool _isPressed = false;

  bool get isPressed => _isPressed; //To check if the answer is pressed

  double _numberOfQuestion = 1;

  double get numberOfQuestion => _numberOfQuestion;

  int? _selectAnswer;

  int? get selectAnswer => _selectAnswer;

  int? _correctAnswer;

  int _countOfCorrectAnswers = 0;

  int get countOfCorrectAnswers => _countOfCorrectAnswers;

  //map for check if the question has been answered
  Map<String, bool> _questionIsAnswered = {};

  //page view controller
  late PageController pageController;

  //timer
  Timer? _timer;

  int maxSec = 45;

  final RxInt _sec = 45.obs;

  RxInt get sec => _sec;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    resetAnswer();

    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    resetTimer();
    super.onClose();
  }

  void addFlag(QuestionModel question) {
    int getIndex = _questionsList.indexOf(question);
    final x = _flagedList.contains(_questionsList[getIndex]);
    if (x) {
      _flagedList.remove(_questionsList[getIndex]);
    } else {
      _flagedList.add(_questionsList[getIndex]);
    }
    update();
  }

  void quizFlagged() {
    _questionsList = _flagedList;
  }

  Map<String, dynamic>? _quizScreenParameter;

  void getParameter(String domain, topic, bool timer) {
    _quizScreenParameter = {
      'domain': domain,
      'topic': topic,
      'timer': timer,
    };
  }

  // double increaseQuestionNumber() {
  //   return _numberOfQuestion++;
  // }

  //get final score
  double get scoreResult {
    return _countOfCorrectAnswers * 100 / _questionsList.length;
  }

  void checkAnswerWithTimer(QuestionModel questionModel, int selectAnswer) {
    _isPressed = true;
    _isSubmit = true;

    _selectAnswer = selectAnswer;
    _correctAnswer = questionModel.answer;

    if (_correctAnswer == _selectAnswer) {
      _countOfCorrectAnswers++;
    }
    stopTimer();
    _questionIsAnswered[questionModel.id] = true;
    update();
  }

  void checkAnswer(QuestionModel questionModel, int selectAnswer) {
    _isPressed = true;
    _isSubmit = true;

    _selectAnswer = selectAnswer;
    _correctAnswer = questionModel.answer;

    if (_correctAnswer == _selectAnswer) {
      _countOfCorrectAnswers++;
    }
    // stopTimer();
    _questionIsAnswered[questionModel.id] = true;
    update();
  }

  void checkIsSubmitted(bool timer) {
    if (timer) {
      Future.delayed(const Duration(milliseconds: 100))
          .then((value) => nextQuestionWithTimer());
    } else {
      Future.delayed(const Duration(milliseconds: 100))
          .then((value) => nextQuestion());
    }
    _isSubmit = false;
  }

  //check if the question has been answered
  bool checkIsQuestionAnswered(String quesId) {
    return _questionIsAnswered.entries.any((element) => element.key == quesId);
  }

  void nextQuestionWithTimer() {
    if (_timer != null || _timer!.isActive) {
      stopTimer();
    }

    if (pageController.page == _questionsList.length - 1) {
      _numberOfQuestion = 1;
      Get.offAndToNamed(ResultScreen.routeName);
    } else {
      _isPressed = false;
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.linear);

      startTimer();
    }
    _numberOfQuestion = pageController.page! + 2;
    update();
  }

  void nextQuestion() {
    // if (_timer != null || _timer!.isActive) {
    //   stopTimer();
    // }

    if (pageController.page == _questionsList.length - 1) {
      _numberOfQuestion = 1;
      Get.offAndToNamed(ResultScreen.routeName);
    } else {
      _isPressed = false;
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.linear);

      // startTimer();
    }
    _numberOfQuestion = pageController.page! + 2;
    update();
  }

  //called when start again quiz
  void resetAnswer() {
    _questionIsAnswered = {};
    update();
  }

  //get right and wrong color
  Color getColor(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Colors.green.shade700;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Colors.red.shade700;
      }
    }
    return Colors.white;
  }

  //het right and wrong icon
  IconData getIcon(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Icons.done;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Icons.close;
      }
    }
    return Icons.close;
  }

  void startTimer() {
    resetTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sec.value > 0) {
        _sec.value--;
      } else {
        stopTimer();
        nextQuestionWithTimer();
      }
    });
  }

  void resetTimer() => _sec.value = maxSec;

  void stopTimer() => _timer!.cancel();

  void backToTopics() {
    _correctAnswer = null;
    _countOfCorrectAnswers = 0;
    _numberOfQuestion = 1;
    _flagedList = [];
    resetAnswer();
    resetTimer();
    _selectAnswer = null;
    _quizScreenParameter = {};
  }

  //call when start again quiz
  void startAgain() {
    _correctAnswer = null;
    _countOfCorrectAnswers = 0;
    _numberOfQuestion = 1;
    _flagedList = [];
    resetAnswer();
    resetTimer();
    _selectAnswer = null;
    _quizScreenParameter = {};
    Get.offAllNamed(UserHomeScreen.routeName);
  }

  void startQuizAgain(BuildContext ctx) {
    _correctAnswer = null;
    _countOfCorrectAnswers = 0;
    _numberOfQuestion = 1;
    _flagedList = [];
    resetAnswer();
    resetTimer();
    _selectAnswer = null;
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          fromFlagged: true,
          domain: _quizScreenParameter!['domain'],
          topic: _quizScreenParameter!['topic'],
          timer: _quizScreenParameter!['timer'],
        ),
      ),
    );
  }
}
