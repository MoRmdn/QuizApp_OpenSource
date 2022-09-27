import 'dart:developer';

import 'package:QuizApp/screens/home_page.dart';
import 'package:QuizApp/widgets/body_constraint.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool _obscureText = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

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
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _email.text,
        password: _pass.text,
      )
          .then((value) {
        if (value.user!.uid == "3o24mZeno5Y4UFKXohjFBOnF2JQ2") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const HomePage(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacementNamed('/user_home_screen');
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showToast('Wrong password provided for that user.');
      }
    } catch (e) {
      log(' error from login Screen  ${e.toString()}');
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dHeight = MediaQuery.of(context).size.height;
    double h = dHeight * 0.3;
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
                                'Welcome Back',
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
                                      'Login',
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context)
                                .pushReplacementNamed("/Registration"),
                            child: const Text("New User !"),
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
                            'Welcome Back',
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
                                  'Login',
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed("/Registration"),
                        child: const Text("Registration"),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
