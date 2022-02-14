import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoResponsiveHomePage extends StatelessWidget {
  const NoResponsiveHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                width: double.infinity,
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/flutter.svg",
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'What is Lorem Ipsum?',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                )))));
  }
}
