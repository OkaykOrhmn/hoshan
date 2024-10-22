// ignore_for_file: deprecated_member_use_from_same_package

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/core/routes/route_generator.dart';
import 'package:hoshan/data/model/on_boarding_slider.dart';
import 'package:hoshan/data/storage/shared_preferences_helper.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/slider/custom_carousel_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final CustomCarouselController _buttonCarouselController =
      CustomCarouselController();
  final ValueNotifier<bool> isEnd = ValueNotifier(false);
  late final CarouselOptions carouselOptions = CarouselOptions(
    viewportFraction: 1,
    initialPage: 0,
    disableCenter: true,
    enableInfiniteScroll: false,
    reverse: false,
    autoPlay: false,
    autoPlayCurve: Curves.fastOutSlowIn,
    enlargeCenterPage: true,
    enlargeFactor: 0.5,
    onPageChanged: (index, _) {},
    scrollDirection: Axis.horizontal,
    height: MediaQuery.sizeOf(context).height,
  );

  final List<OnBoardingSlider> sliders = [
    OnBoardingSlider(
        id: 0,
        image: Assets.image.boardings.board1,
        title:
            'هوشان، یک تیم دانش‌بنیان در حوزه مدل‌های زبانی هوش مصنوعی است که در سال 1398 شروع به کار کرد. هدف این محصول، ساده‌تر و ارزان‌تر کردن دسترسی کاربران به ابزارهای مبتنی بر هوش مصنوعی است.'),
    OnBoardingSlider(
        id: 1,
        image: Assets.image.boardings.board2,
        title:
            'ما در هوشان، متعهد به ارتقای دانش و هموارسازی راه پیشرفت همه‌ی فارسی‌زبانان هستیم. ما بر این باوریم که هوش مصنوعی ابزاری قدرتمند برای یادگیری و رشد در جهان امروز و پیش شرطی برای ورود به آینده است. در هوشان ابزارهای مختلف هوش مصنوعی را برای کمک به فارسی‌زبانان در یادگیری و پیشرفت شغلی و فردی ارائه می‌دهیم.'),
    OnBoardingSlider(
        id: 2,
        image: Assets.image.boardings.board3,
        title:
            'بدون شما هیچ ارزشی خلق نخواهد شد. ما روی شما حساب کرده‌ایم. با به اشتراک گذاشتن تجربه کاربری خود در هوشان با دوستانتان و یا کسانی که می‌توانند از هوشان بهره مند شوند، ما را در ایفای رسالت اجتماعی خود یاری کنید.')
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 46,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  CarouselSlider.builder(
                      carouselController: _buttonCarouselController,
                      itemCount: sliders.length,
                      itemBuilder: (context, index, realIndex) {
                        return sliderView(index);
                      },
                      options: carouselOptions),
                  Positioned.fill(
                      child: Center(
                    child: sliderIndicator(),
                  ))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: ValueListenableBuilder<bool>(
              valueListenable: isEnd,
              builder: (context, value, child) {
                return Row(
                  children: [
                    if (!value)
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                OnBoardingStorage.setBoradingStatus(false);
                                Navigator.pushReplacementNamed(
                                    context, Routes.auth);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.gray[400],
                                  elevation: 0),
                              child: Text('انصراف',
                                  style: AppTextStyles.body4
                                      .copyWith(color: AppColors.gray[800]))),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            if (value) {
                              OnBoardingStorage.setBoradingStatus(false);
                              Navigator.pushReplacementNamed(
                                  context, Routes.auth);
                              return;
                            }
                            _buttonCarouselController.nextPage();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.secondryColor.defaultShade),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                value ? 'بزن بریم' : 'بعدی',
                                style: AppTextStyles.body4
                                    .copyWith(color: Colors.white),
                              ),
                              Assets.icon.outline.arrowRight
                                  .svg(color: Colors.white)
                            ],
                          )),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget sliderIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 120.0),
      child: FutureBuilder(
          future: _buttonCarouselController.onReady,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _buttonCarouselController.state!.pageController!.addListener(() {
                if (_buttonCarouselController.state!.pageController!.page! >
                    1.5) {
                  isEnd.value = true;
                } else {
                  isEnd.value = false;
                }
              });
              return SmoothPageIndicator(
                  controller: _buttonCarouselController.state!.pageController!,
                  count: sliders.length,
                  effect: ExpandingDotsEffect(
                      dotWidth: 8,
                      dotHeight: 8,
                      activeDotColor: AppColors.secondryColor.defaultShade,
                      dotColor: AppColors.secondryColor.defaultShade));
            }
            return const SizedBox();
          }),
    );
  }

  Widget sliderView(int index) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 80.0),
        child: sliders[index].image.svg(),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: Text(
          sliders[index].title,
          style: AppTextStyles.body3,
          textDirection: TextDirection.rtl,
        ),
      )
    ]);
  }
}
