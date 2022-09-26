import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:QuizApp/provider/data_provider.dart';
import 'package:QuizApp/screens/quiz_screen.dart';
import 'package:QuizApp/widgets/body_constraint.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../models/create_quiz.dart';

// ignore: must_be_immutable
class TopicsScreen extends StatefulWidget {
  static const routeName = '/topics_screen';
  String? domainKey;
  String? domainValue;

  TopicsScreen({
    Key? key,
    this.domainKey,
    this.domainValue,
  }) : super(key: key);

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  final _db =
      FirebaseFirestore.instance.collection('DB').doc('h60FQ93NHwIx4sGvedTY');
  List? topics;

  Future<void> getDomainTopics() async {
    final mapList = await _db
        .collection(widget.domainKey!)
        .doc(domainID[widget.domainKey!])
        .get();
    setState(() {
      topics = mapList['Topics'];
    });
  }

  Future<void> getQuestions(String topics) async {
    // .fetchData(widget.domainValue!, topics);
    Get.find<QuizController>().fetchData(widget.domainValue!, topics);
  }

  void startWithTimer(String topic) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          Get.find<QuizController>().startTimer();
          return QuizScreen(
            domain: widget.domainValue!,
            topic: topic,
            timer: true,
          );
        },
      ),
    );
  }

  void start(String topic) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return QuizScreen(
            domain: widget.domainValue!,
            topic: topic,
            timer: false,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getDomainTopics();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.domainKey!,
        ),
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        //shadowColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFF6AF56),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ResponsiveBuilder(
        builder: (ctx, constraints) => constraints.deviceScreenType ==
                DeviceScreenType.desktop
            ? BodyWidget(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                widget.domainValue!,
                                minFontSize: 35,
                                maxFontSize: 50,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF6AF56),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 60),
                        child: Card(
                          child: SingleChildScrollView(
                            child: Column(
                              children: topics != null
                                  ? topics!.map((e) {
                                      return InkWell(
                                        onTap: () {
                                          getQuestions(e);

                                          AwesomeDialog(
                                            width: 500,
                                            context: context,
                                            dialogType: DialogType.infoReverse,
                                            animType: AnimType.scale,
                                            title: 'Timed Quiz',
                                            desc:
                                                'do you want to start Quiz with timer 45s for the question',
                                            btnCancelOnPress: () => start(e),
                                            btnOkOnPress: () =>
                                                startWithTimer(e),
                                          ).show();
                                        },
                                        child: ListTile(
                                          title: Text(
                                            e,
                                            style: const TextStyle(
                                              fontSize: 25,
                                            ),
                                          ),
                                          trailing: const Icon(
                                              Icons.arrow_forward_ios),
                                        ),
                                      );
                                    }).toList()
                                  : [
                                      const Center(
                                        child: Text('No Topics add yet'),
                                      )
                                    ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 20, right: 20, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                widget.domainValue!,
                                minFontSize: 20,
                                maxFontSize: 25,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(
                                    0xFFF6AF56,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Card(
                        child: SingleChildScrollView(
                          child: Column(
                            children: topics != null
                                ? topics!.map((e) {
                                    return InkWell(
                                      onTap: () {
                                        getQuestions(e);
                                        AwesomeDialog(
                                          width: 500,
                                          context: context,
                                          dialogType: DialogType.infoReverse,
                                          animType: AnimType.rightSlide,
                                          title: 'Timed Quiz',
                                          desc:
                                              'do you want to start Quiz with timer 45s for the question',
                                          btnCancelOnPress: () => start(e),
                                          btnOkOnPress: () => startWithTimer(e),
                                        ).show();
                                      },
                                      child: ListTile(
                                        title: Text(e),
                                        trailing:
                                            const Icon(Icons.arrow_forward_ios),
                                      ),
                                    );
                                  }).toList()
                                : [
                                    const SizedBox(
                                      height: 250,
                                    ),
                                    const Center(
                                      child: Text('No Topics add yet'),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
