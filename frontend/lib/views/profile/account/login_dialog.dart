import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/helper.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../widgets/custom_buttons.dart';
import 'components/forgot_password.dart';
import 'components/signin_fields.dart';
import 'components/signup_fields.dart';

class LoginDialog extends StatelessWidget {
  final bool isSignup;
  const LoginDialog({super.key, this.isSignup = false});

  @override
  Widget build(BuildContext context) => Helper.isMobile
      ? Material(child: _buildLoginContent())
      : AlertDialog(
          backgroundColor: kNeutralColor100,
          surfaceTintColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: _buildLoginContent(),
        );

  GetBuilder<AuthenticationService> _buildLoginContent() => GetBuilder<AuthenticationService>(
        initState: (state) {
          if (state.controller?.currentState != LoginWidgetState.signup && isSignup) {
            WidgetsBinding.instance.addPostFrameCallback((_) => state.controller?.currentState = LoginWidgetState.signup);
          }
        },
        builder: (controller) {
          return DecoratedBox(
            decoration: BoxDecoration(color: kNeutralColor100, borderRadius: regularRadius),
            child: AnimatedContainer(
              width: Helper.isMobile
                  ? Get.width
                  : controller.currentState.isSignUp
                      ? 700
                      : 450,
              height: Helper.isMobile ? Get.height * 0.9 : 700,
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  // Header
                  DecoratedBox(
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kNeutralLightColor, width: 0.7))),
                    child: Padding(
                      padding: const EdgeInsets.all(Paddings.regular),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButtons.icon(onPressed: () => Helper.goBack(), icon: const Icon(Icons.close)),
                          Text(
                            controller.currentState.isSignUp
                                ? 'signup'.tr
                                : controller.currentState.isLogin
                                    ? 'login'.tr
                                    : 'forgot_password'.tr,
                            style: AppFonts.x15Bold,
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Helper.isMobile || controller.currentState.isChangePassword ? 0 : Paddings.exceptional),
                      child: LayoutBuilder(
                        builder: (context, constraints) => SizedBox(
                          height: constraints.maxHeight,
                          child: Form(
                            key: controller.formLoginKey,
                            child: controller.currentState.isSignUp
                                ? SignUpFields(maxHeight: constraints.maxHeight)
                                : controller.currentState.isLogin
                                    ? Helper.isMobile
                                        ? const SingleChildScrollView(padding: EdgeInsets.symmetric(horizontal: Paddings.extraLarge), child: SignInFields())
                                        : const SignInFields()
                                    : const SingleChildScrollView(padding: EdgeInsets.symmetric(horizontal: Paddings.extraLarge), child: ForgotPassword()),
                          ),
                        ),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: kNeutralLightColor, width: 0.7))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Paddings.exceptional, vertical: Paddings.regular),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(controller.currentState.isLogin ? 'have_no_account_msg'.tr : 'have_account_msg'.tr, style: AppFonts.x12Regular),
                          CustomButtons.text(
                            onPressed: () => controller.currentState.isLogin ? controller.currentState = LoginWidgetState.signup : controller.currentState = LoginWidgetState.login,
                            title: controller.currentState.isLogin ? 'create_account'.tr : 'login'.tr,
                            titleStyle: AppFonts.x12Bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
