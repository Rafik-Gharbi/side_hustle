import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../helpers/helper.dart';
import '../repositories/params_repository.dart';
import '../services/theme/theme.dart';
import 'custom_buttons.dart';
import 'custom_text_field.dart';

enum FeedbackEmotion {
  disappointed(value: 'disappointed', color: Color.fromRGBO(26, 35, 126, 1)),
  meh(value: 'meh', color: Colors.grey),
  okay(value: 'okay', color: Color.fromRGBO(253, 216, 53, 1)),
  happy(value: 'happy', color: Colors.orange),
  inLove(value: 'in_love', color: Color.fromRGBO(220, 44, 41, 1));

  final String value;
  final Color color;

  const FeedbackEmotion({required this.value, required this.color});
}

class EmotionSliderBottomsheet extends StatefulWidget {
  const EmotionSliderBottomsheet({super.key});

  @override
  EmotionSliderBottomsheetState createState() => EmotionSliderBottomsheetState();
}

class EmotionSliderBottomsheetState extends State<EmotionSliderBottomsheet> {
  final TextEditingController commentController = TextEditingController();
  double _currentValue = 2;
  bool isCommentExpanded = false;

  void submitFeedback() => ParamsRepository.find.submitFeedback(FeedbackEmotion.values[_currentValue.round()], commentController.text);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kNeutralColor100,
      child: Stack(
        children: [
          EmotionSlider(
            currentLevel: _currentValue,
            onLevelChanged: (value) => setState(() => _currentValue = value),
            isCommentExpanded: isCommentExpanded,
            onExpandComment: (value) => setState(() => isCommentExpanded = value),
            commentController: commentController,
            onSubmitFeedback: submitFeedback,
          ),
          Positioned(
            top: 30,
            right: 20,
            child: CustomButtons.icon(icon: const Icon(Icons.close, color: kNeutralColor100), onPressed: Get.back),
          )
        ],
      ),
    );
  }
}

class EmotionSlider extends StatelessWidget {
  final double currentLevel;
  final ValueChanged<double> onLevelChanged;
  final bool isCommentExpanded;
  final ValueChanged<bool> onExpandComment;
  final TextEditingController commentController;
  final void Function() onSubmitFeedback;

  const EmotionSlider({
    super.key,
    required this.currentLevel,
    required this.onLevelChanged,
    required this.isCommentExpanded,
    required this.onExpandComment,
    required this.commentController,
    required this.onSubmitFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: ColorTween(
        begin: FeedbackEmotion.values[0].color,
        end: FeedbackEmotion.values[currentLevel.round()].color,
      ),
      duration: const Duration(milliseconds: 500),
      builder: (context, Color? color, child) {
        final textColor = Helper.isColorDarkEnoughForWhiteText(color!) ? kBlackColor : kNeutralColor100;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: color,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: Text('how_was_your_experience'.tr, style: AppFonts.x24Bold.copyWith(color: textColor), textAlign: TextAlign.center),
              ),
              const SizedBox(height: Paddings.exceptional * 1.5),
              // Emotion Face
              AnimatedFacePainter(emotionLevel: currentLevel),
              const SizedBox(height: Paddings.exceptional),
              // Emotion Name
              Text(
                FeedbackEmotion.values[currentLevel.round()].value.tr,
                style: AppFonts.x24Bold.copyWith(color: textColor),
              ),
              const SizedBox(height: Paddings.exceptional),
              // Emotion Slider
              Slider(
                value: currentLevel,
                min: 0,
                max: 4,
                divisions: 4,
                activeColor: Colors.white,
                onChanged: onLevelChanged,
              ),
              const SizedBox(height: Paddings.exceptional),
              AnimatedContainer(
                duration: Durations.medium1,
                height: isCommentExpanded ? 180 : 40,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => onExpandComment.call(!isCommentExpanded),
                        child: Row(
                          children: [
                            Icon(Icons.comment_outlined, color: textColor),
                            const SizedBox(width: Paddings.regular),
                            Text('add_comment'.tr, style: AppFonts.x14Regular.copyWith(color: textColor)),
                          ],
                        ),
                      ),
                      if (isCommentExpanded)
                        Padding(
                          padding: const EdgeInsets.only(top: Paddings.regular),
                          child: CustomTextField(
                            hintText: 'how_could_improve'.tr,
                            fieldController: commentController,
                            outlinedBorder: true,
                            isTextArea: true,
                          ),
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Paddings.exceptional),
              CustomButtons.elevatePrimary(
                title: 'submit_feedback'.tr,
                titleStyle: AppFonts.x16Bold,
                buttonColor: kNeutralLightColor,
                width: double.infinity,
                onPressed: onSubmitFeedback,
              )
            ],
          ),
        );
      },
    );
  }
}

class AnimatedFacePainter extends StatefulWidget {
  final double emotionLevel;

  const AnimatedFacePainter({super.key, required this.emotionLevel});

  @override
  AnimatedFacePainterState createState() => AnimatedFacePainterState();
}

class AnimatedFacePainterState extends State<AnimatedFacePainter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _emotionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Duration of the animation transition
      vsync: this,
    );

    _emotionAnimation = Tween<double>(begin: 0.0, end: widget.emotionLevel).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedFacePainter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.emotionLevel != oldWidget.emotionLevel) {
      // Animate from the old emotion level to the new one
      _emotionAnimation = Tween<double>(begin: _emotionAnimation.value, end: widget.emotionLevel).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _emotionAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 200), // Face size
          painter: FacePainter(emotionLevel: _emotionAnimation.value),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Custom painter to draw the face
class FacePainter extends CustomPainter {
  final double emotionLevel;

  FacePainter({required this.emotionLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw face circle
    paint.color = Colors.white;
    canvas.drawCircle(Offset(centerX, centerY), size.width * 0.45, paint);

    // Draw eyes
    const eyeSize = 20.0;
    final leftEyeX = centerX - size.width * 0.15;
    final rightEyeX = centerX + size.width * 0.15;
    final eyeY = centerY - size.height * 0.15;
    paint.color = Colors.black;

    // Eye expression changes slightly based on emotion level
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(leftEyeX, eyeY - emotionLevel * 1.5), // Move eyes slightly up/down
        width: eyeSize,
        height: eyeSize * (1.0 + 0.3 * (emotionLevel - 2).abs()), // Different expressions
      ),
      paint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(rightEyeX, eyeY - emotionLevel * 1.5),
        width: eyeSize,
        height: eyeSize * (1.0 + 0.3 * (emotionLevel - 2).abs()),
      ),
      paint,
    );

    // Draw mouth
    double smileHeight = emotionLevel <= 2
        ? size.height * 0.05 * (emotionLevel - 2) // Sad to neutral
        : size.height * 0.07 * (emotionLevel - 2); // Neutral to smile
    if (smileHeight == 0) smileHeight = 2;
    final mouthPath = Path()
      ..moveTo(leftEyeX, centerY + size.height * 0.15)
      ..quadraticBezierTo(centerX, centerY + size.height * 0.15 + smileHeight, rightEyeX, centerY + size.height * 0.15);
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 5.0;
    paint.strokeCap = StrokeCap.round;
    canvas.drawPath(mouthPath, paint);
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.emotionLevel != emotionLevel;
  }
}
