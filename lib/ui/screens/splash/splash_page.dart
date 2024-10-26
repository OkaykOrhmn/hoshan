import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/core/routes/route_generator.dart';
import 'package:hoshan/data/storage/shared_preferences_helper.dart';
import 'package:hoshan/ui/screens/splash/cubit/user_info_cubit.dart';
import 'package:hoshan/ui/theme/colors.dart';
import 'package:hoshan/ui/theme/text.dart';
import 'package:hoshan/ui/widgets/components/button/loading_button.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool boardingStatus = OnBoardingStorage.getBoradingStatus();
      String authToken = AuthTokenStorage.getToken();
      if (boardingStatus) {
        Navigator.pushReplacementNamed(context, Routes.onBoarding);
      } else {
        if (authToken.isEmpty) {
          Navigator.pushReplacementNamed(context, Routes.auth);
        } else {
          context.read<UserInfoCubit>().getUserInfo();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor.defaultShade,
      body: BlocConsumer<UserInfoCubit, UserInfoState>(
        listener: (context, state) {
          if (state is UserInfoSuccess) {
            Navigator.pushReplacementNamed(context, Routes.home);
          } else if (state is UserInfoFail) {
            Navigator.pushReplacementNamed(context, Routes.auth);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Positioned.fill(child: Assets.image.splash.splash.svg()),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.image.appIcon.svg(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'هــوشان',
                        style: AppTextStyles.headline1
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    Text(
                      '... جهان برای کشف از آنِ توست',
                      style: AppTextStyles.body3.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 200,
                  right: 0,
                  left: 0,
                  child: state is UserInfoConnectionError
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Center(
                            child: LoadingButton(
                              width: MediaQuery.sizeOf(context).width / 2,
                              height: 46,
                              radius: 10,
                              onPressed: () =>
                                  context.read<UserInfoCubit>().getUserInfo(),
                              child: Text(
                                'تلاش مجدد',
                                style: AppTextStyles.body4.copyWith(
                                    color: AppColors.black.defaultShade),
                              ),
                            ),
                          ),
                        )
                      : const CupertinoActivityIndicator(
                          radius: 24,
                          color: Colors.white,
                        ))
            ],
          );
        },
      ),
    );
  }
}
