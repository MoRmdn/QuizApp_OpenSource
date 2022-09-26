import 'dart:developer';

import 'package:QuizApp/screens/auth/login_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../widgets/body_constraint.dart';

class Registration extends StatefulWidget {
  static const routeName = '/Registration';
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _fbAuth = FirebaseAuth.instance;
  final _fbStore = FirebaseFirestore.instance;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool _obscureText = true;
  bool _loading = false;

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 20.0,
    );
  }

  Future<void> _onSave() async {
    if (_email.text == '' ||
        !_email.text.contains('@') ||
        !_email.text.contains('.com')) {
      showToast('enter valid Email');
      return;
    }
    if (_name.text == '' || _name.text.length < 3) {
      showToast('enter valid name');
      return;
    }
    if (_pass.text == '' || _pass.text.length < 6) {
      showToast('enter valid password');
      return;
    }
    if (_pass.text.length < 6) {
      showToast('password should be more than 6 characters');
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await _fbAuth
          .createUserWithEmailAndPassword(
            email: _email.text,
            password: _pass.text,
          )
          .then(
            (value) async =>
                await _fbStore.collection("Users").doc(value.user!.uid).set(
              {
                "name": _name.text,
              },
            ),
          )
          .then((value) =>
              Navigator.of(context).pushReplacementNamed('/user_home_screen'));
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        showToast('email-already-in-use');
      } else if (error.code == "invalid-email") {
        showToast("invalid-email");
      } else if (error.code == "operation-not-allowed") {
        showToast('operation-not-allowed');
      } else if (error.code == "weak-password") {
        showToast('weak-password');
      } else {
        showToast('Some thing wrong happen');
      }
    } catch (e) {
      log(' error from registration Screen  ${e.toString()}');
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dHeight = MediaQuery.of(context).size.height;
    double h = dHeight * 0.4;
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (ctx, constraints) {
          return constraints.deviceScreenType == DeviceScreenType.desktop
              ? Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/login_new.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BodyWidget(
                    hRatio: 0.5,
                    wRatio: 0.6,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              AutoSizeText(
                                "Hello Newbie",
                                minFontSize: 40,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 100),
                            child: TextFormField(
                              controller: _name,
                              decoration: InputDecoration(
                                // fillColor: Colors.yellowAccent,
                                labelText: 'Name',
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 100),
                            child: TextFormField(
                              controller: _email,
                              decoration: InputDecoration(
                                // fillColor: Colors.yellowAccent,
                                labelText: 'Email',
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 100),
                            child: TextFormField(
                              controller: _pass,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                // fillColor: Colors.yellowAccent,
                                // fillColor: const Color(0xFFF6AF56),
                                // hoverColor: const Color(0xFFF6AF56),
                                labelText: 'Password',
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    semanticLabel: _obscureText
                                        ? 'show password'
                                        : 'hide password',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFF6AF56),
                              ),
                            ),
                            onPressed: _onSave,
                            child: _loading
                                ? Center(
                                    child: SizedBox(
                                      width: 100,
                                      child: GlowingProgressIndicator(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Loading",
                                            ),
                                            JumpingDotsProgressIndicator(
                                              fontSize: 14,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    child: Text(
                                      'Register',
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            ),
                            child: const Text("Have Email ?"),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: h,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          AutoSizeText(
                            'Hello Newbie',
                            minFontSize: 25,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: _name,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: _pass,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                semanticLabel: _obscureText
                                    ? 'show password'
                                    : 'hide password',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: _onSave,
                        child: _loading
                            ? GlowingProgressIndicator(
                                child: Center(
                                  child: SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Loading",
                                        ),
                                        JumpingDotsProgressIndicator(
                                          fontSize: 14,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  'Register',
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        ),
                        child: const Text("Have Email ?"),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
