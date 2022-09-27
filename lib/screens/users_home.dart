import 'package:QuizApp/screens/home_page.dart';
import 'package:QuizApp/screens/topics.dart';
import 'package:QuizApp/widgets/body_constraint.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../models/create_quiz.dart';

class UserHomeScreen extends StatelessWidget {
  static const routeName = '/user_home_screen';
  UserHomeScreen({Key? key}) : super(key: key);
  final _userAuth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (ctx, constraints) => Scaffold(
        body: constraints.deviceScreenType == DeviceScreenType.desktop
            ? BodyWidget(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_userAuth!.uid == "3o24mZeno5Y4UFKXohjFBOnF2JQ2")
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const HomePage(),
                                ),
                              ),
                              child: const Text(
                                "Add Questions",
                              ),
                            ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/');
                              FirebaseAuth.instance.signOut();
                            },
                            icon: const Icon(
                              Icons.logout,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                AutoSizeText(
                                  'Start ',
                                  minFontSize: 50,
                                  maxFontSize: 50,
                                  style: TextStyle(),
                                ),
                                AutoSizeText(
                                  'Quiz',
                                  minFontSize: 50,
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
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: GridView.count(
                          childAspectRatio: 5,
                          crossAxisCount: 1,
                          mainAxisSpacing: 50,
                          children: domainNamesForUser.map((e) {
                            String? _domain;
                            String? _domainName;

                            e.forEach((key, value) {
                              _domain = key;
                              _domainName = value;
                            });

                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => TopicsScreen(
                                      domainKey: _domain!,
                                      domainValue: _domainName!,
                                    ),
                                  ),
                                );
                              },
                              child: GridTile(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image(
                                    image: AssetImage(domainsPhoto[_domain]!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                footer: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                  //borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
                                  child: GridTileBar(
                                      backgroundColor: Colors.black38,
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _domain!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 23,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            _domainName!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 23,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_userAuth!.uid == "3o24mZeno5Y4UFKXohjFBOnF2JQ2")
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const HomePage(),
                            ),
                          ),
                          child: const Text(
                            "Add Questions",
                          ),
                        ),
                      IconButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        icon: const Icon(
                          Icons.logout,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            AutoSizeText(
                              'Start ',
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
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: GridView.count(
                        childAspectRatio: 2.5,
                        crossAxisCount: 1,
                        mainAxisSpacing: 10,
                        children: domainNamesForUser.map((e) {
                          String? x;
                          String? y;
                          e.forEach((key, value) {
                            x = key;
                            y = value;
                          });
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => TopicsScreen(
                                          domainKey: x!,
                                          domainValue: y!,
                                        )),
                              );
                            },
                            child: GridTile(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image(
                                  image: AssetImage(domainsPhoto[x]!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              footer: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                //borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
                                child: GridTileBar(
                                    backgroundColor: Colors.black38,
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          x!,
                                          maxFontSize: 20,
                                          minFontSize: 10,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        AutoSizeText(
                                          y!,
                                          maxFontSize: 20,
                                          minFontSize: 10,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
