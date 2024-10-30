import 'package:flutter/material.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/data/model/products_model.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/button/loading_button.dart';
import 'package:hoshan/ui/widgets/sections/header/reversible_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherProductsPage extends StatefulWidget {
  const OtherProductsPage({super.key});

  @override
  State<OtherProductsPage> createState() => _OtherProductsPageState();
}

class _OtherProductsPageState extends State<OtherProductsPage> {
  final List<ProductsModel> _listProducts = [
    ProductsModel(
        title: 'اپلیکیشن رصد استراتژیک',
        description:
            'مدیریت استراتژیک و آینده نگاری در کسب و کارهای ایرانی در بهترین حالت ...',
        image: Assets.image.products.strategicMonitoring,
        link: 'https://irfartak.com/products/didvan'),
    ProductsModel(
        title: 'اپلیکیشن میکرولرنینگ',
        description:
            'یادگیری خرد تنها به آموزش کارمندان محدود نخواهد شد و مشتریان هم می‌توانند ...',
        image: Assets.image.products.ajhman),
    ProductsModel(
        title: 'سامانه هم اندیشی آنلاین',
        description:
            'خرد جمعی، همیشه مفهومی والا برای اذهان بشر بوده است. با وجود آنکه «همه چیز را ...',
        image: Assets.image.products.onlineThink,
        link: 'https://irfartak.com/products/saha'),
    ProductsModel(
        title: 'پلتفرم رادار روند',
        description:
            'روندها واضح‌ترین وجوه آینده و خطوط کلی آنچه احتمالا آینده خواهد بود را ...',
        image: Assets.image.products.radar,
        link: 'https://irfartak.com/products/trend-radar'),
    ProductsModel(
        title: 'پلتفرم رادار ریسک',
        description:
            'ریسک‌‌ها این موجودات خطرناک تا وقتی مدیریت می‌‌شوند درست مثل کروکودیل‌‌های ...',
        image: Assets.image.products.risk,
        link: 'https://irfartak.com/products/risk-radar')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReversibleAppbar(
        titleText: 'سایر محصولات ما',
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
            itemCount: _listProducts.length,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 32),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final product = _listProducts[index];
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        product.image.image(),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: AppTextStyles.body3.copyWith(
                                  color: AppColors.primaryColor.defaultShade,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              product.description,
                              style: AppTextStyles.body5,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            if (product.link != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  LoadingButton(
                                      height: 32,
                                      radius: 46,
                                      color:
                                          AppColors.secondryColor.defaultShade,
                                      onPressed: () async {
                                        if (!await launchUrl(
                                          Uri.parse(product.link!),
                                          mode: LaunchMode.externalApplication,
                                        )) {
                                          throw Exception(
                                              'Could not launch ${product.link}');
                                        }
                                      },
                                      child: Text(
                                        'ادامه',
                                        style: AppTextStyles.body4.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )),
                                ],
                              )
                          ],
                        ))
                      ],
                    ),
                  ),
                  if (index != _listProducts.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        color: AppColors.gray.defaultShade,
                      ),
                    )
                ],
              );
            }),
      ),
    );
  }
}
