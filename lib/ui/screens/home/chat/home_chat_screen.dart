import 'package:flutter/cupertino.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/dropdown/bots_search_dropdown.dart';
import 'package:hoshan/ui/widgets/components/slider/carousle_slider_banners.dart';

class HomeChatScreen extends StatefulWidget {
  const HomeChatScreen({super.key});

  @override
  State<HomeChatScreen> createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends State<HomeChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: CarousleSliderBanners(banners: ['', '', '', '', '']),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: BotSearchDropdown(),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
                color: AppColors.gray[200],
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              'به جعبه ابزار هوشان خوش آمدید. من اینجا هستم تا پاسخگوی سوالات شما باشم. امیدوارم در استفاده از هوشان تجربه خوبی داشته باشید!',
              style: AppTextStyles.body5,
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(
            height: 30000,
          )
        ],
      ),
    );
  }
}
