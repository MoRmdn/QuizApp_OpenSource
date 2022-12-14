import 'dart:developer';
import 'dart:html';

import 'package:QuizApp/models/create_quiz.dart';
import 'package:QuizApp/screens/users_home.dart';
import 'package:QuizApp/widgets/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class FormBuilderPC extends StatefulWidget {
  const FormBuilderPC({Key? key}) : super(key: key);

  @override
  State<FormBuilderPC> createState() => _FormBuilderPCState();
}

class _FormBuilderPCState extends State<FormBuilderPC> {
  final _db =
      FirebaseFirestore.instance.collection('DB').doc('h60FQ93NHwIx4sGvedTY');
  final _storage = FirebaseStorage.instance;
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _domain = TextEditingController();
  final TextEditingController _topic = TextEditingController();
  final TextEditingController _question = TextEditingController();
  final TextEditingController _correctAnswer = TextEditingController();
  final TextEditingController _illustration = TextEditingController();
  final TextEditingController _a2 = TextEditingController();
  final TextEditingController _a3 = TextEditingController();
  final TextEditingController _a4 = TextEditingController();
  final QuizCreate _create = QuizCreate();
  bool _loadingTopics = false;
  bool _loadingImage = false;
  bool _loading = false;
  String? correctAnswer;
  List _existingTopicsList = ['Existing Topics'];
  List _existingDomainList = ['Existing Domains'];
  String? dropDownDomain;
  String? dropDownTopic;
  File? _image;
  String? imageURL;
  bool loadingDomains = true;

  @override
  void dispose() {
    _domain.dispose();
    _topic.dispose();
    _question.dispose();
    _correctAnswer.dispose();
    _illustration.dispose();
    _a2.dispose();
    _a3.dispose();
    _a4.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getExistingDomainValues();
    super.initState();
  }

  Future<void> getExistingDomainValues() async {
    final oldDomainsSnap = await _db.get();
    final oldDomains = oldDomainsSnap.data();
    if (oldDomains!.isNotEmpty) {
      _existingDomainList = oldDomains["Domains"];
      log("there is domains");
    }
    setState(() {
      loadingDomains = false;
    });
  }

  Future<void> getImage(File image) async {
    _image = image;
    final _ref =
        _storage.ref().child('images').child(DateTime.now().toString());

    /// how to upload image from web
    setState(() {
      _loadingImage = true;
    });
    await _ref.putBlob(_image);
    imageURL = await _ref.getDownloadURL().whenComplete(() => log('Complete'));

    setState(() {
      _loadingImage = false;
    });
  }

  Future<void> getTopics() async {
    _existingTopicsList = ['Existing Topics'];
    if (_existingTopicsList.length == 1) {
      setState(() {
        _loadingTopics = true;
      });
      var mapList = await _db
          .collection(_domain.text)
          .doc("${_domain.text.trim()}_Path")
          .get();
      if (mapList.exists) {
        setState(() {
          _existingTopicsList = mapList['Topics'];

          _loadingTopics = false;
        });
      }
      setState(() {
        _loadingTopics = false;
      });
    }
  }

  // Future<void> _test() async {
  //   final DB = FirebaseFirestore.instance.collection('DB');
  //   DB.get().then((value) {
  //     print(value.size);
  //     if (value.size > 0) {
  //       value.docs.map((e) {
  //         print(e);
  //       }).toList();
  //       setState(() {});
  //     }
  //   }).catchError((error) {
  //     print(error);
  //   });
  // }

  Future<void> _onSave() async {
    List<String> answers = [];

    answers.addAll([
      _a3.text,
      _correctAnswer.text,
      _a4.text,
      _a2.text,
    ]);
    List<String> newList = answers..shuffle();

    setState(() {
      _loading = true;
    });

    await _db
        .collection(_domain.text)
        .doc("${_domain.text}_Path")
        .collection(_topic.text)
        .doc()
        .set({
      'imageURl': imageURL,
      'question': _question.text,
      'correctAnswer': _correctAnswer.text,
      'illustration': _illustration.text,
      'answers': newList,
    }).then((value) {
      if (!_existingDomainList.contains(_domain.text)) {
        _existingDomainList.add(
          _domain.text,
        );
        _existingDomainList.remove('Existing Domains');
        _db.set({
          "Domains": _existingDomainList,
        });
      }
    });

    if (!_existingTopicsList.contains(_topic.text)) {
      _existingTopicsList.add(_topic.text);
      _existingTopicsList.remove('Existing Topics');
      await _db
          .collection(_domain.text)
          .doc("${_domain.text.trim()}_Path")
          .set({
        'Topics': _existingTopicsList,
      });
    }

    setState(() {
      _loading = false;
    });
    _question.clear();
    _correctAnswer.clear();
    _illustration.clear();
    _a2.clear();
    _a3.clear();
    _a4.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 70),
      child: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _domain,
                      decoration:
                          const InputDecoration(hintText: 'Domain Name'),
                      onChanged: (val) {
                        setState(() {
                          getTopics();
                        });
                      },
                    ),
                  ),
                  loadingDomains
                      ? Expanded(
                          child: JumpingDotsProgressIndicator(
                            fontSize: 50,
                            color: Colors.blueAccent,
                          ),
                        )
                      : Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(25),
                            hint: const Text('Existing Domains'),
                            value: dropDownDomain,
                            items: _existingDomainList
                                .map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(value: e, child: Text(e));
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue != "Existing Domains") {
                                  _domain.text = newValue!;
                                } else {
                                  _domain.text = '';
                                }
                                getTopics();
                              });
                            },
                            icon: const Icon(Icons.keyboard_arrow_down),
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _topic,
                      decoration: const InputDecoration(hintText: 'Topic Name'),
                      onChanged: (val) {
                        setState(() {
                          getTopics();
                        });
                      },
                    ),
                  ),
                  _loadingTopics
                      ? Expanded(
                          child: JumpingDotsProgressIndicator(
                          fontSize: 50,
                          color: Colors.blueAccent,
                        ))
                      : Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(25),
                            hint: const Text("Existing Topics"),
                            value: dropDownTopic,
                            items: _existingTopicsList
                                .map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(value: e, child: Text(e));
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue != "Existing Topics") {
                                  _topic.text = newValue!;
                                }
                              });
                            },
                            icon: const Icon(Icons.keyboard_arrow_down),
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: 8,
                      controller: _question,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          hintText: 'Question'),
                      onSaved: (value) {
                        _create.Q = value!;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ///////////////// upload images

              _loadingImage
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            ))
                      ],
                    )
                  : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      PickImage(
                        getImage: getImage,
                      ),
                    ]),

              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: 3,
                        controller: _correctAnswer,
                        decoration:
                            const InputDecoration(hintText: 'Correct Answer'),
                        onSaved: (value) {
                          _create.correctAnswer = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50, left: 70),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: 2,
                        controller: _illustration,
                        decoration:
                            const InputDecoration(hintText: 'Explanation'),
                        onSaved: (value) {
                          _create.illustration = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: 3,
                        controller: _a2,
                        decoration: const InputDecoration(hintText: 'Answer 2'),
                        onSaved: (value) {
                          _create.a2 = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: 3,
                        controller: _a3,
                        decoration: const InputDecoration(hintText: 'Answer 3'),
                        onSaved: (value) {
                          _create.a3 = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: 3,
                        controller: _a4,
                        decoration: const InputDecoration(hintText: 'Answer 4'),
                        onSaved: (value) {
                          _create.a4 = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                    onPressed: _onSave,
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text('Submit'))),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const UserHomeScreen(),
                        ),
                      );
                    },
                    child: const Text('Home')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
