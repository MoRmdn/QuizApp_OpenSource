import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../provider/data_provider.dart';

class AnswerOption extends StatelessWidget {
  const AnswerOption({
    Key? key,
    required this.timer,
    required this.answer,
    required this.index,
    required this.questionId,
    required this.onPressed,
  }) : super(key: key);

  final String answer;
  final int index;
  final String questionId;
  final bool timer;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      builder: (controller) => ResponsiveBuilder(
        builder: (ctx, constraints) => constraints.deviceScreenType ==
                DeviceScreenType.desktop
            ? InkWell(
                onTap: () {
                  if (!controller.checkIsQuestionAnswered(questionId)) {
                    onPressed();
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 5,
                        color: controller.getColor(index),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: answer,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          if (controller.checkIsQuestionAnswered(questionId) &&
                              controller.selectAnswer == index)
                            Container(
                              width: 30,
                              height: 30,
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: controller.getColor(index),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  shape: BoxShape.circle),
                              child: Icon(
                                controller.getIcon(index),
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : InkWell(
                onTap: () {
                  if (!controller.checkIsQuestionAnswered(questionId)) {
                    onPressed();
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 5,
                        color: controller.getColor(index),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: answer,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          if (controller.checkIsQuestionAnswered(questionId) &&
                              controller.selectAnswer == index)
                            Container(
                              width: 30,
                              height: 30,
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: controller.getColor(index),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  shape: BoxShape.circle),
                              child: Icon(
                                controller.getIcon(index),
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
