import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:QuizApp/widgets/quiz/flag.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../models/question_model.dart';
import '../../provider/data_provider.dart';
import 'answer_option.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel questionsModel;
  final bool timer;
  final bool flag;

  const QuestionCard({
    Key? key,
    required this.timer,
    required this.questionsModel,
    required this.flag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(questionsModel.id);
    return ResponsiveBuilder(
      builder: (ctx, constraints) => constraints.deviceScreenType ==
              DeviceScreenType.desktop
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: const Color(0xffF4F5F8),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questionsModel.question,
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    // if (!flag)
                    FlagIcon(
                      questionsModel: questionsModel,
                    ),
                    if (questionsModel.imageURL != null &&
                        questionsModel.imageURL != '')
                      SizedBox(
                        height: 300,
                        child: Image.network(questionsModel.imageURL!),
                      ),
                    const SizedBox(height: 30),
                    ...List.generate(
                      questionsModel.options.length,
                      (index) => Column(
                        children: [
                          AnswerOption(
                            questionId: questionsModel.id,
                            answer: questionsModel.options[index].toString(),
                            index: index,
                            timer: timer,
                            onPressed: () {
                              if (timer) {
                                Get.find<QuizController>().checkAnswerWithTimer(
                                    questionsModel, index);
                              } else {
                                Get.find<QuizController>()
                                    .checkAnswer(questionsModel, index);
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: 800,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: const Color(0xffF4F5F8),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questionsModel.question,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      if (!flag)
                        FlagIcon(
                          questionsModel: questionsModel,
                        ),
                      if (questionsModel.imageURL != null &&
                          questionsModel.imageURL != '')
                        SizedBox(
                          height: 300,
                          child: Image.network(questionsModel.imageURL!),
                        ),
                      const SizedBox(height: 30),
                      ...List.generate(
                        questionsModel.options.length,
                        (index) => Column(
                          children: [
                            AnswerOption(
                              questionId: questionsModel.id,
                              answer: questionsModel.options[index].toString(),
                              index: index,
                              timer: timer,
                              onPressed: () {
                                if (timer) {
                                  Get.find<QuizController>()
                                      .checkAnswerWithTimer(
                                          questionsModel, index);
                                } else {
                                  Get.find<QuizController>()
                                      .checkAnswer(questionsModel, index);
                                }
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
