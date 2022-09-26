import 'package:QuizApp/widgets/body_constraint.dart';
import 'package:QuizApp/widgets/form/form_builder.dart';
import 'package:QuizApp/widgets/form/form_builder_mobile.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (ctx, constraints) => Scaffold(
        backgroundColor: Colors.black12,
        body: constraints.deviceScreenType == DeviceScreenType.desktop
            ? BodyWidget(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                },
                                icon: const Icon(Icons.logout))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          AutoSizeText(
                            'Create ',
                            minFontSize: 30,
                            maxFontSize: 50,
                            style: TextStyle(),
                          ),
                          AutoSizeText(
                            'Quiz',
                            minFontSize: 30,
                            maxFontSize: 50,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(
                                0xFFF6AF56,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const FormBuilderPC(),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                              },
                              icon: const Icon(Icons.logout))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        AutoSizeText(
                          'Create ',
                          minFontSize: 30,
                          maxFontSize: 50,
                          // style: TextStyle(),
                        ),
                        AutoSizeText(
                          'Quiz',
                          minFontSize: 30,
                          maxFontSize: 50,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    const FormBuilderMobile(),
                  ],
                ),
              ),
      ),
    );
  }
}
