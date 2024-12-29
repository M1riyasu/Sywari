import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sywari/helpers/pages_helpers.dart';
import 'package:sywari/models/user_model.dart';
import 'package:sywari/pages/tabs_screen.dart';
import 'package:sywari/services/preferences_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _splashTimer(BuildContext context) async {
    try {
      await Future.wait(<Future>[
        PreferencesService.init(),
      ]);
      if (Provider.of<UserModel>(context, listen: false).splashDone) return;
      Provider.of<UserModel>(context, listen: false).splashDone = true;

      Provider.of<UserModel>(context, listen: false).loadUserData();
    } catch (e) {
      print(e);
    }
  }

  void init(BuildContext context) async {
    _splashTimer(context);
    PreferencesService.setBool('requireUpdate', true);
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Material(
      color: Color(0xFF0f3b5e),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Builder(
              builder: (context) {
                // Получаем ширину экрана
                double screenWidth = MediaQuery.of(context).size.width;

                return Container(
                  width: screenWidth / 3, // Ширина — треть экрана
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/splash.png'),
                      fit: BoxFit.cover, // Чтобы изображение растягивалось по всему контейнеру
                    ),
                  ),
                );
              },
            ),
          ),
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Home(),
          ),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    _isRequireUpdate();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        PagesHelpers.loadPageReplace(context, const TabsScreen());
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double barWidth = MediaQuery.of(context).size.width * 0.75;
    return Center(
      child: Container(
        width: barWidth,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, snapshot) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomPaint(
                painter: MyCustomPainter(controller.value),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String> _receiveTimeFromServer() async {
    try {
      var uri = Uri.parse('http://192.168.1.239:8080/api/files/earliest/time');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = (response.body);

        return data as String;
      } else {
        return '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Произошла ошибка: $e')),
      );
      print(e);
      return '';
    }
  }

  Future<void> _isRequireUpdate() async {
    await Future.wait(<Future>[
      PreferencesService.init(),
    ]);
    if (PreferencesService.getString('scheduleTime') != null &&
        PreferencesService.getString('scheduleTime') ==
            await _receiveTimeFromServer()) {
      PreferencesService.setBool('requireUpdate', true);
    } else {
      PreferencesService.setBool('requireUpdate', true);
    }
  }
}

class MyCustomPainter extends CustomPainter {
  final double percentage;

  MyCustomPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width * percentage, size.height),
      const Radius.circular(10),
    );
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
