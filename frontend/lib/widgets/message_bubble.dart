import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../services/theme/theme.dart';

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String searchText;
  final DateTime date;
  final bool loggedUser;
  final bool showDate;

  const MessageBubble({super.key, required this.msgText, required this.date, required this.loggedUser, this.searchText = '', required this.showDate});

  @override
  Widget build(BuildContext context) => Container(
        margin: loggedUser ? const EdgeInsets.only(left: Paddings.exceptional) : const EdgeInsets.only(right: Paddings.exceptional),
        child: Padding(
          padding: const EdgeInsets.all(Paddings.small),
          child: Align(
            alignment: loggedUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: loggedUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (showDate)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                    child: Text(DateFormat.Hm().format(date), style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
                  ),
                Material(
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(30),
                    topLeft: loggedUser ? const Radius.circular(30) : const Radius.circular(0),
                    bottomRight: const Radius.circular(30),
                    topRight: loggedUser ? const Radius.circular(0) : const Radius.circular(30),
                  ),
                  color: loggedUser ? Colors.blue : kNeutralLightColor,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: searchText.isEmpty || !msgText.contains(searchText)
                        ? Text(
                            msgText,
                            style: AppFonts.x14Regular.copyWith(color: loggedUser ? kNeutralColor100 : kBlackColor),
                          )
                        : RichText(
                            text: TextSpan(
                              style: AppFonts.x14Regular.copyWith(color: loggedUser ? kNeutralColor100 : kBlackColor),
                              children: [
                                TextSpan(text: msgText.substring(0, msgText.indexOf(searchText))),
                                TextSpan(text: searchText, style: AppFonts.x14Bold.copyWith(color: loggedUser ? kNeutralColor100 : kBlackColor)),
                                TextSpan(text: msgText.substring(msgText.indexOf(searchText) + searchText.length)),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
