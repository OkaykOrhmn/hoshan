import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/slider/custom_carousel_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarousleSliderBanners extends StatefulWidget {
  final List<String> banners;
  const CarousleSliderBanners({super.key, required this.banners});

  @override
  State<CarousleSliderBanners> createState() => _CarousleSliderBannersState();
}

class _CarousleSliderBannersState extends State<CarousleSliderBanners> {
  final CustomCarouselController _buttonCarouselController =
      CustomCarouselController();

  @override
  Widget build(BuildContext context) {
    final CarouselOptions carouselOptions = CarouselOptions(
      viewportFraction: 0.8,
      initialPage: 0,
      disableCenter: false,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true,
      enlargeFactor: 0.2,
      onPageChanged: (index, _) {},
      scrollDirection: Axis.horizontal,
      aspectRatio: 16 / 9,
      height: 180,
    );
    return Stack(
      children: [
        CarouselSlider.builder(
            carouselController: _buttonCarouselController,
            itemCount: widget.banners.length,
            itemBuilder: (context, index, realIndex) {
              return sliderView(widget.banners[index]);
            },
            options: carouselOptions),
        Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: Center(child: sliderIndicator())),
      ],
    );
  }

  Widget placeholderView({final Widget? child}) {
    return Container(
      height: 180,
      decoration: BoxDecoration(color: AppColors.gray[100]),
      child: child,
    );
  }

  Widget sliderView(String banner) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl:
                  "https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg",
              placeholder: (context, url) => placeholderView(),
              errorWidget: (context, url, error) => placeholderView(
                child: Center(
                  child: Icon(
                    Icons.image_not_supported_rounded,
                    size: 60,
                    color: AppColors.primaryColor.defaultShade,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 12,
          bottom: 8,
          child: SizedBox(
            height: 32,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.secondryColor.defaultShade.withOpacity(0.5)),
                child: Text(
                  'بیشتر',
                  style: AppTextStyles.body5.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
          ),
        )
      ],
    );
  }

  Widget sliderIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 120.0),
      child: FutureBuilder(
          future: _buttonCarouselController.onReady,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _buttonCarouselController.state!.pageController!
                  .addListener(() {});
              return SmoothPageIndicator(
                  controller: _buttonCarouselController.state!.pageController!,
                  count: widget.banners.length,
                  effect: ExpandingDotsEffect(
                      dotWidth: 8,
                      dotHeight: 8,
                      activeDotColor: AppColors.primaryColor.defaultShade,
                      dotColor: AppColors.primaryColor[50]));
            }
            return const SizedBox();
          }),
    );
  }
}
