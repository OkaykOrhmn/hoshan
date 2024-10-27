import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/gen/assets.gen.dart';

import 'package:hoshan/data/model/ai/bots_model.dart';
import 'package:hoshan/ui/screens/home/cubit/home_cubit_cubit.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/dropdown/cubit/all_bots_cubit.dart';
import 'package:hoshan/ui/widgets/sections/loading/default_placeholder.dart';

class BotSearchDropdown extends StatefulWidget {
  const BotSearchDropdown({super.key});

  @override
  State<BotSearchDropdown> createState() => _BotSearchDropdownState();
}

class _BotSearchDropdownState extends State<BotSearchDropdown> {
  late final CustomDropdownDecoration customDropdownDecoration =
      CustomDropdownDecoration(
          expandedFillColor: AppColors.gray[200],
          closedFillColor: const Color(0xffE0ECFF),
          closedSuffixIcon: Icon(
            Icons.arrow_drop_down_rounded,
            color: AppColors.primaryColor.defaultShade,
          ),
          expandedSuffixIcon: Icon(
            Icons.arrow_drop_up_rounded,
            color: AppColors.primaryColor.defaultShade,
          ),
          overlayScrollbarDecoration: Theme.of(context).scrollbarTheme);

  final List<Bots> _list = [];

  Future<List<Bots>> _getFakeRequestData(String query) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return _list.where((e) {
        return e.name.toString().toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<AllBotsCubit, AllBotsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AllBotsSuccess) {
            _list.addAll(state.bots);
          }
          if (state is AllBotsFail) {
            return const SizedBox();
          }
          return DefaultPlaceHolder(
            enabled: state is AllBotsLoading,
            child: CustomDropdown<Bots>.searchRequest(
              items: _list,
              futureRequest: _getFakeRequestData,
              searchHintText: 'جستجو در بات ها',
              overlayHeight: MediaQuery.sizeOf(context).height / 2.2,
              canCloseOutsideBounds: false,
              excludeSelected: false,
              headerBuilder: botView,
              hintBuilder: hintView,
              listItemBuilder: listItemView,
              decoration: customDropdownDecoration,
              onChanged: (value) {
                HomeCubit.bot = value;
              },
            ),
          );
        },
      ),
    );
  }

  Widget listItemView(BuildContext context, Bots item, bool isSelected,
      void Function() onItemSelect) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          botView(context, item, true),
          if (_list.last != item)
            Divider(
              color: AppColors.gray[500],
            )
        ],
      ),
    );
  }

  Widget hintView(BuildContext context, String hint, bool enabled) {
    return Row(
      children: [
        Assets.icon.outline.brain.svg(width: 18, height: 18),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Center(
            child: Text(
              'انتخاب نوع هوش مصنوعی',
              style: AppTextStyles.body4.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Row botView(BuildContext context, Bots item, bool enabled) {
    return Row(
      children: [
        ClipOval(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CachedNetworkImage(
              imageUrl: item.image!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name!,
                  style:
                      AppTextStyles.body3.copyWith(fontWeight: FontWeight.bold),
                ),
                // Text(
                //   item.description,
                //   style: AppTextStyles.body5.copyWith(
                //       color: AppColors.gray[800],
                //       overflow: TextOverflow.ellipsis),
                //   maxLines: 1,
                // )
              ],
            ),
          ),
        ),
        // if (item.lock)
        //   Container(
        //     width: 24,
        //     height: 24,
        //     decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: AppColors.primaryColor.defaultShade),
        //     child: const Icon(
        //       Icons.lock,
        //       size: 12,
        //       color: Colors.white,
        //     ),
        //   )
      ],
    );
  }
}
