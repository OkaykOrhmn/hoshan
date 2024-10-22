import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/dropdown/simple_dropdown.dart';
import 'package:shamsi_date/shamsi_date.dart';

class PersianDatePicker extends StatefulWidget {
  const PersianDatePicker({super.key});

  @override
  State<PersianDatePicker> createState() => _PersianDatePickerState();
}

class _PersianDatePickerState extends State<PersianDatePicker> {
  final Jalali initialDate = Jalali.now();
  final Jalali startDate = Jalali(1390);
  late int persianMonthIndex = initialDate.month;
  late String persianYearSelected = initialDate.year.toString();
  final CarouselSliderControllerImpl controllerImpl =
      CarouselSliderControllerImpl();

  final List<Jalali> selectedDates = [];

  List<String> persianMonths = [
    "فروردین",
    "اردیبهشت",
    "خرداد",
    "تیر",
    "مرداد",
    "شهریور",
    "مهر",
    "آبان",
    "آذر",
    "دی",
    "بهمن",
    "اسفند"
  ];

  List<String> daysOfWeek = [
    "شنبه",
    "یک شنبه",
    "دو شنبه",
    "سه شنبه",
    "چهار شنبه",
    "پنج شنبه",
    "جمعه"
  ];

  List<int> days = [];
  List<int> getDaysOfMonth() {
    final List<int> days = [];
    final date = Jalali(int.parse(persianYearSelected), persianMonthIndex);
    int monthLength = date.monthLength;
    final day = Jalali(int.parse(persianYearSelected), persianMonthIndex, 1);
    int index = daysOfWeek.indexOf(day.formatter.wN);
    for (var i = 0; i < index; i++) {
      days.add(0);
    }
    for (var i = 1; i <= monthLength; i++) {
      days.add(i);
    }
    this.days = days;
    return days;
  }

  List<String> years = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i <= initialDate.year - startDate.year; i++) {
      years.add((startDate.year + i).toString());
    }
    years = years.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppColors.black.defaultShade.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0)
          ]),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'انتخاب تاریخ',
              style: AppTextStyles.body4.copyWith(
                  fontWeight: FontWeight.bold, color: AppColors.black[900]),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'تاریخ روز: ${initialDate.day} ${persianMonths[initialDate.month - 1]} ${initialDate.year}',
              style: AppTextStyles.body4.copyWith(color: AppColors.black[600]),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: SimpleDropdown(
                    initialItem: years.first,
                    list: years,
                    onSelect: (selected) {
                      setState(() {
                        persianYearSelected = years[selected];
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: SimpleDropdown(
                    initialItem: persianMonths[persianMonthIndex - 1],
                    list: persianMonths,
                    onSelect: (selected) {
                      controllerImpl
                          .animateToPage(selected)
                          .then((value) => setState(() {
                                persianMonthIndex = selected + 1;
                              }));
                    },
                  ),
                ),
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: daysOfWeek.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, crossAxisSpacing: 16, mainAxisSpacing: 16),
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    daysOfWeek[index].split(' ').first,
                    style: AppTextStyles.body5,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
            CarouselSlider.builder(
              carouselController: controllerImpl,
              itemBuilder: (context, index, realIndex) {
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: getDaysOfMonth().length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16),
                  itemBuilder: (context, index) {
                    return days[index] == 0
                        ? const SizedBox()
                        : InkWell(
                            onTap: () {
                              setState(() {
                                final date = Jalali(
                                    int.parse(persianYearSelected),
                                    persianMonthIndex,
                                    days[index]);
                                if (selectedDates.contains(date)) {
                                  selectedDates.remove(date);
                                } else {
                                  selectedDates.add(date);
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: persianMonthIndex ==
                                              (initialDate.month) &&
                                          (days[index]) == initialDate.day &&
                                          (selectedDates.contains(Jalali(
                                              int.parse(persianYearSelected),
                                              persianMonthIndex,
                                              days[index])))
                                      ? Border.all(
                                          color: AppColors
                                              .secondryColor.defaultShade)
                                      : null,
                                  color: persianMonthIndex ==
                                              (initialDate.month) &&
                                          (days[index]) == initialDate.day
                                      ? AppColors.gray[200]
                                      : selectedDates.contains(Jalali(
                                              int.parse(persianYearSelected),
                                              persianMonthIndex,
                                              days[index]))
                                          ? AppColors.secondryColor.defaultShade
                                          : null),
                              child: Text(
                                '${days[index]}',
                                style: AppTextStyles.body4.copyWith(
                                    color: selectedDates.contains(Jalali(
                                                int.parse(persianYearSelected),
                                                persianMonthIndex,
                                                days[index])) &&
                                            !(persianMonthIndex ==
                                                    (initialDate.month) &&
                                                (days[index]) ==
                                                    initialDate.day)
                                        ? Colors.white
                                        : AppColors.black.defaultShade),
                              ),
                            ),
                          );
                  },
                );
              },
              itemCount: persianMonths.length,
              options: CarouselOptions(
                viewportFraction: 1,
                initialPage: persianMonthIndex - 1,
                disableCenter: false,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                height: 6 * 52,
                onPageChanged: (index, reason) {
                  setState(() {
                    if (reason == CarouselPageChangedReason.manual) {
                      persianMonthIndex = index + 1;
                    }
                  });
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
            Divider(
              color: AppColors.gray.defaultShade,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'انصراف',
                      style: AppTextStyles.body4
                          .copyWith(color: AppColors.gray[900]),
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'تایید',
                      style: AppTextStyles.body4
                          .copyWith(color: AppColors.primaryColor.defaultShade),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
