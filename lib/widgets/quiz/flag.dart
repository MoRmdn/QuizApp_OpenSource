import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:QuizApp/provider/data_provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../models/question_model.dart';

class FlagIcon extends StatefulWidget {
  final QuestionModel questionsModel;

  const FlagIcon({
    Key? key,
    required this.questionsModel,
  }) : super(key: key);

  @override
  State<FlagIcon> createState() => _FlagIconState();
}

class _FlagIconState extends State<FlagIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      builder: (controller) => ResponsiveBuilder(
        builder: (ctx, constraints) =>
            constraints.deviceScreenType == DeviceScreenType.desktop
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isPressed = !_isPressed;
                            controller.addFlag(widget.questionsModel);
                          });
                        },
                        icon: Icon(
                          _isPressed ? Icons.flag : Icons.flag_outlined,
                          color: _isPressed
                              ? const Color(0xFFF6AF56)
                              : const Color(0xff2C3848),
                          size: 40,
                        ),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isPressed = !_isPressed;
                            controller.addFlag(widget.questionsModel);
                          });
                        },
                        icon: Icon(
                          _isPressed ? Icons.flag : Icons.flag_outlined,
                          size: 25,
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}
