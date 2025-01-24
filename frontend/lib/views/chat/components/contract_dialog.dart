import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/helper.dart';
import '../../../models/contract.dart';
import '../../../repositories/chat_repository.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';

class ContractDialog extends StatelessWidget {
  final Contract contract;
  final void Function() onRejectContract;
  final void Function() onSignContract;
  final RxBool isLoading;
  const ContractDialog({super.key, required this.contract, required this.onRejectContract, required this.onSignContract, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    bool isContractAccepted = false;
    return SafeArea(
      child: Material(
        color: kNeutralColor100,
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(Paddings.small),
          child: SizedBox(
            width: Get.width * 0.9,
            child: FutureBuilder<File?>(
              future: ChatRepository.find.getContract(contract.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final isProvider = contract.provider?.id == AuthenticationService.find.jwtUserData?.id;
                    final isSeeker = contract.seeker?.id == AuthenticationService.find.jwtUserData?.id;
                    isContractAccepted = isProvider ? contract.isSigned : contract.isPayed;
                    return Padding(
                      padding: const EdgeInsets.all(Paddings.small),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: Paddings.small),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 40),
                                Text('new_contract'.tr, style: AppFonts.x16Bold),
                                CustomButtons.icon(icon: const Icon(Icons.close), onPressed: () => Helper.goBack()),
                              ],
                            ),
                          ),
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(borderRadius: smallRadius, border: regularBorder),
                              child: Padding(
                                padding: const EdgeInsets.all(Paddings.small),
                                child: SfPdfViewer.file(snapshot.data!),
                              ),
                            ),
                          ),
                          StatefulBuilder(
                            builder: (context, setState) => InkWell(
                              onTap: () => contract.isSigned && isProvider || contract.isPayed && isSeeker ? null : setState(() => isContractAccepted = !isContractAccepted),
                              child: Row(
                                children: [
                                  Checkbox(
                                    activeColor: Colors.green, // Background color of the checkbox when checked
                                    checkColor: Colors.white, // Tick color when checked
                                    value: isContractAccepted,
                                    onChanged: (value) =>
                                        contract.isSigned && isProvider || contract.isPayed && isSeeker ? null : setState(() => isContractAccepted = value ?? false),
                                  ),
                                  const SizedBox(width: Paddings.regular),
                                  Text('accept_contract_terms'.tr, style: AppFonts.x14Regular),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: Paddings.small),
                          // Provider side
                          if (isProvider)
                            if (contract.isSigned)
                              Center(
                                child: CustomButtons.elevatePrimary(
                                  title: 'done'.tr,
                                  width: 200,
                                  onPressed: Helper.goBack,
                                ),
                              )
                            else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButtons.elevateSecondary(
                                    title: 'reject'.tr,
                                    loading: isLoading,
                                    width: 150,
                                    onPressed: () {
                                      onRejectContract();
                                      Helper.goBack();
                                    },
                                  ),
                                  CustomButtons.elevatePrimary(
                                    title: 'done'.tr,
                                    loading: isLoading,
                                    width: 150,
                                    onPressed: () {
                                      if (isContractAccepted) {
                                        onSignContract();
                                        Helper.goBack();
                                      } else {
                                        Helper.snackBar(message: 'sign_contract_first_msg'.tr);
                                      }
                                    },
                                  ),
                                ],
                              )
                          else if (isSeeker)
                            // Seeker side
                            if (contract.isPayed)
                              Center(
                                child: CustomButtons.elevatePrimary(
                                  title: 'done'.tr,
                                  width: 200,
                                  onPressed: Helper.goBack,
                                ),
                              )
                            else
                              Center(
                                child: CustomButtons.elevatePrimary(
                                  title: 'pay_contract'.tr,
                                  loading: isLoading,
                                  width: 150,
                                  disabled: !contract.isSigned,
                                  onPressed: () {
                                    if (isContractAccepted) {
                                      onSignContract();
                                      Helper.goBack();
                                    } else {
                                      Helper.snackBar(message: 'sign_contract_first_msg'.tr);
                                    }
                                  },
                                ),
                              ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Align(alignment: Alignment.centerRight, child: CustomButtons.icon(icon: const Icon(Icons.close), onPressed: Get.back)),
                        Expanded(
                          child: Center(child: Text('error_occurred'.tr, style: AppFonts.x14Regular)),
                        ),
                      ],
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
