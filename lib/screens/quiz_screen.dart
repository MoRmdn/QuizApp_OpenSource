import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../provider/data_provider.dart';
import '../widgets/body_constraint.dart';
import '../widgets/custom_button.dart';
import '../widgets/progress_timer.dart';
import '../widgets/quiz/question_card.dart';

class QuizScreen extends StatelessWidget {
  static const routeName = '/quiz_screen';
  String? domain;
  String? topic;
  bool? timer;
  bool? fromFlagged;

  QuizScreen({
    Key? key,
    this.domain,
    this.topic,
    this.timer,
    this.fromFlagged = false,
  }) : super(key: key);

  int num = 1;

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return GetBuilder<QuizController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(domain! + '/' + topic!),
          centerTitle: true,
          elevation: 0,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          //shadowColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              controller.backToTopics();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFFF6AF56),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: ResponsiveBuilder(builder: (ctx, constraints) {
          controller.getParameter(domain!, topic!, timer!);
          return constraints.deviceScreenType == DeviceScreenType.desktop
              ? controller.countOfQuestion == 0
                  ? BodyWidget(
                      child: const Center(
                        child: Text('No Questions loaded yet'),
                      ),
                    )
                  : BodyWidget(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Spacer(),
                                  RichText(
                                    text: TextSpan(
                                        text: 'Question ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(
                                              color: Colors.black,
                                            ),
                                        children: [
                                          TextSpan(
                                            text: num.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .copyWith(
                                                  color: Colors.black,
                                                ),
                                          ),
                                          TextSpan(
                                            text: '/',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(
                                                  color: Colors.black,
                                                ),
                                          ),
                                          TextSpan(
                                            text: controller.countOfQuestion
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(
                                                  color: Colors.black,
                                                ),
                                          ),
                                        ]),
                                  ),
                                  const Spacer(),
                                  if (timer!) ProgressTimer(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 1500,
                              child: PageView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => QuestionCard(
                                  flag: fromFlagged!,
                                  timer: timer!,
                                  questionsModel:
                                      controller.questionsList[index],
                                ),
                                controller: controller.pageController,
                                itemCount: controller.questionsList.length,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
              : controller.countOfQuestion == 0
                  ? BodyWidget(
                      child: const Center(
                        child: Text('No Questions loaded yet'),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: 'Question ',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: num.toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '/',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                          ),
                                        ),
                                        TextSpan(
                                          text: controller.countOfQuestion
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ]),
                                ),
                                if (timer!) ProgressTimer(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 600,
                            child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => QuestionCard(
                                flag: fromFlagged!,
                                timer: timer!,
                                questionsModel: controller.questionsList[index],
                              ),
                              controller: controller.pageController,
                              itemCount: controller.questionsList.length,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    );
        }),
        floatingActionButton: controller.isSubmit
            ? CustomButton(
                color: const Color(0xff2C3848),
                onPressed: () {
                  num++;
                  // controller.increaseQuestionNumber();
                  controller.checkIsSubmitted(timer!);
                },
                text: 'Next Question',
              )
            : const SizedBox(),
      ),
    );
  }
}
