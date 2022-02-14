import 'package:esizer/esizer.dart';
import 'package:example/generated/dimen_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResponsiveHomePage extends StatelessWidget {
  const ResponsiveHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: EdgeInsets.all(DimenKeys.homeScreenContentPadding.sw),
                color: Colors.white,
                width: double.infinity,
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/flutter.svg",
                      width: DimenKeys.homeScreenIconSize.sw,
                      height: DimenKeys.homeScreenIconSize.sw,
                    ),
                    SizedBox(
                      height: DimenKeys.homeScreenWidgetSpaceSize.h,
                    ),
                    Text(
                      'What is Lorem Ipsum?',
                      style: TextStyle(
                          fontSize: DimenKeys.homeScreenTitleTextSize.sp),
                    ),
                    SizedBox(
                      height: DimenKeys.homeScreenWidgetSpaceSize.h,
                    ),
                    Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                      style: TextStyle(
                          fontSize: DimenKeys.homeScreenDescriptionTextSize.sp),
                    ),
                  ],
                )))));
  }
}
