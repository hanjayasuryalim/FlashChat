import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../components/padding_widget.dart';

class WelcomeScreen extends StatefulWidget {
  static const String route = "/welcome";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

// if you want to add only one animation use with Singletickerproviderstatemixin
class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController backgroundController;
  AnimationController tweenController;
  Animation animation;
  Animation tweenAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this, // determine  the ticker, which is this class
    );
    controller.reverse(from: 1.0); // animation.dismissed
    controller.addListener(() {
      setState(() {});
    });
    // BACKGROUND ANIMATION
    backgroundController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    backgroundController.forward(); // animation.completed
    backgroundController.addListener(() {
      setState(() {});
    });
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    // animation expect upperbound to be <= 1
    animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        controller.forward();
      } else if (status == AnimationStatus.completed) {
        controller.reverse(from: 1.0);
      }
    });
    // TWEEN ANIMATION
    tweenController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    tweenAnimation = ColorTween(begin: Colors.red, end: Colors.blueAccent)
        .animate(tweenController);
    tweenController.forward();
    tweenController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.lightBlueAccent.withOpacity(backgroundController.value),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: tweenAnimation.value),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            PaddingWidget(
              txt: 'Log in',
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.route);
              },
            ),
            PaddingWidget(
              txt: 'Register',
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.route);
              },
            ),
            Text('${controller.value * 100}%')
          ],
        ),
      ),
    );
  }
}
