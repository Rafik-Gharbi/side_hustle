import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../services/theme/theme.dart';

class OverflowedTextWithTooltip extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final bool expand;

  /// This widget generally should be put inside a row or a column since it start with an expanded to get all the available space.
  /// It only requires the [title] to put in the Text widget.
  /// If the [title] is short and not overflowed the tooltip will be disabled.
  ///
  const OverflowedTextWithTooltip({required this.title, this.style, this.expand = true, super.key});

  // This layoutBuilder is used to detect if the title will be overflowed or not, to assign a tooltip with it if so.
  Widget buildOverflowedTextWithTooltip() => LayoutBuilder(
        builder: (context, size) {
          final TextSpan span = TextSpan(text: title, style: style ?? AppFonts.x14Regular);
          final TextPainter tp = TextPainter(maxLines: 1, textAlign: TextAlign.left, textDirection: TextDirection.ltr, text: span);
          tp.layout(maxWidth: size.maxWidth);
          // whether the text overflowed or not
          final bool exceeded = tp.didExceedMaxLines;
          return Tooltip(
            message: exceeded ? title : '',
            child: Text(
              title.replaceAll('', '\u{200B}'),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: style ?? AppFonts.x14Regular.copyWith(color: kBlackColor, fontWeight: FontWeight.w400),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) => expand ? Expanded(child: buildOverflowedTextWithTooltip()) : buildOverflowedTextWithTooltip();
}