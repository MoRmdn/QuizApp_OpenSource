import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:QuizApp/widgets/body_constraint.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../provider/data_provider.dart';
import '../../widgets/custom_button.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);
  static const routeName = '/result_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2B3848),
      body: GetBuilder<QuizController>(
        builder: (controller) => ResponsiveBuilder(
          builder: (ctx, constraints) => constraints.deviceScreenType ==
                  DeviceScreenType.desktop
              ? BodyWidget(
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (controller.scoreResult >= 60)
                              Text(
                                'Congratulation',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                            const SizedBox(
                              height: 50,
                            ),
                            Text(
                              'Your Score is',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${controller.scoreResult.round()} ',
                                  style: TextStyle(
                                      fontSize: 50,
                                      color: controller.scoreResult >= 60
                                          ? Colors.green
                                          : Colors.red),
                                ),
                                const Text(
                                  '/100',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.blueAccent),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment:
                                  controller.flaggedList.isNotEmpty
                                      ? MainAxisAlignment.spaceEvenly
                                      : MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                  tag: 'home',
                                  color: const Color(0xFFF6AF56),
                                  onPressed: () {
                                    controller.startAgain();
                                  },
                                  text: 'Back Home',
                                ),
                                if (controller.flaggedList.isNotEmpty)
                                  CustomButton(
                                    tag: 'flag',
                                    color: const Color(0xff2C3848),
                                    icon: Icons.flag,
                                    onPressed: () {
                                      controller.quizFlagged();
                                      controller.startQuizAgain(context);
                                    },
                                    text: 'Flagged',
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (controller.scoreResult >= 60)
                            const Text(
                              'Congratulation',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            'Your Score is',
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${controller.scoreResult.round()} ',
                                style: TextStyle(
                                    fontSize: 50,
                                    color: controller.scoreResult >= 60
                                        ? Colors.green
                                        : Colors.red),
                              ),
                              const Text(
                                '/100',
                                style: TextStyle(
                                    fontSize: 30, color: Colors.blueAccent),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: controller.flaggedList.isNotEmpty
                                ? MainAxisAlignment.spaceEvenly
                                : MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                color: const Color(0xFFF6AF56),
                                onPressed: () {
                                  controller.startAgain();
                                },
                                text: 'Back Home',
                              ),
                              if (controller.flaggedList.isNotEmpty)
                                CustomButton(
                                  color: const Color(0xff2C3848),
                                  icon: Icons.flag,
                                  onPressed: () {
                                    controller.quizFlagged();
                                    controller.startQuizAgain(context);
                                  },
                                  text: 'Flagged',
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
