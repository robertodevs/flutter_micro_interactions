import 'package:flutter/material.dart';

/// DeliverySendButton microinteraction
///
/// This class contains a button to be tapped
/// whe the button is tapped tha animation starts
/// firt the send message will be hidden, then a transition starts
/// and Sending waiting message will appear and finally a Delivered
/// message will be shown to the user.
///
/// This microinteraction contains only Implicit animations of Flutter
class DeliveryMicroInteractionScreen extends StatefulWidget {
  @override
  _DeliveryMicroInteractionScreenState createState() =>
      _DeliveryMicroInteractionScreenState();
}

class _DeliveryMicroInteractionScreenState
    extends State<DeliveryMicroInteractionScreen>
    with SingleTickerProviderStateMixin {
  final kMainColorMicroInteraction = Color(0xFFFD8350);

  /// Initial icon
  Icon iconButton = Icon(Icons.send, color: Color(0xFFFD8350));

  /// Text initial button
  String textButton = 'Send Message';

  // isFinal Icon enable
  bool isFinalIcon = false;

  /// Fist animation transition sizes
  double orangeMaskWidth = 20.0;
  double orangeMaskHeight = 20.0;

  // Mask Orange initial position
  double leftPositionMaskOrange = 50;
  double topPositionMaskOrange = 15;

  double opacityMaskOrange = 0;

  /// Background Color
  Color backgroundColor = Color(0xFFFD8350);

  /// Dynamic Letter Spacing for the sending label
  double sendingTextSpacing = 0;
  double leftTextPosition = -50;
  double opacitySendingText = 0;

  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColorMicroInteraction,
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        color: backgroundColor,
        child: Center(
          child: Stack(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  opacityMaskOrange = 1;
                  // Putting the mask orange above the button
                  setState(() {
                    orangeMaskHeight = 60.0;
                    orangeMaskWidth = MediaQuery.of(context).size.width * 0.6;
                    leftPositionMaskOrange = 0;
                    topPositionMaskOrange = 0;
                    backgroundColor = Colors.white;
                  });
                  // Wait while the button is changing of status
                  // Showing the sending text animated
                  // This is the first entry for the text and then the text
                  // will keep on the middle
                  setState(() {
                    opacitySendingText = 1.0;
                    sendingTextSpacing = 5.0;
                    leftTextPosition = 90;
                  });
                  await Future.delayed(Duration(milliseconds: 500));
                  // streching the text
                  setState(() {
                    sendingTextSpacing = 1.0;
                  });

                  // Wait a little to see the sending information
                  await Future.delayed(Duration(milliseconds: 600));

                  // Exit of the text, this is the inverse of the
                  // last animation
                  setState(() {
                    sendingTextSpacing = 5.0;
                    leftTextPosition = 250;
                  });
                  await Future.delayed(Duration(milliseconds: 500));
                  // Final animation part
                  setState(() {
                    sendingTextSpacing = 1.0;
                  });
                  await Future.delayed(Duration(milliseconds: 500));

                  // Time to reduce the orange mask again.
                  setState(() {
                    orangeMaskHeight = 20.0;
                    orangeMaskWidth = 20.0;
                    leftPositionMaskOrange = 50;
                    topPositionMaskOrange = 20;
                    backgroundColor = kMainColorMicroInteraction;
                    textButton = 'Delivered';
                  });

                  // Returning the text to the original status
                  leftTextPosition = -50;
                  opacitySendingText = 0;
                  await Future.delayed(Duration(milliseconds: 500));

                  // Final Delivered completed.
                  setState(() {
                    isFinalIcon = true;
                    opacityMaskOrange = 0;
                  });

                  // Return back the initial text
                  await Future.delayed(Duration(milliseconds: 1500));
                  isFinalIcon = false;

                  /// Text initial button
                  textButton = 'Send Message';
                  setState(() {
                    /* Refreshing the final UI
                     */
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 50,
                      ),
                      isFinalIcon
                          ? Icon(
                              Icons.check_circle,
                              color: kMainColorMicroInteraction,
                              size: 24,
                            )
                          : iconButton,
                      SizedBox(
                        width: 20,
                      ),
                      Text(textButton,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14))
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              // The container is put on the exact
              // position of the send icon and then when the button is pressed
              // this orange mask will appear smoothly
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                left: leftPositionMaskOrange,
                top: topPositionMaskOrange,
                curve: Curves.easeInOut,
                child: Opacity(
                  opacity: opacityMaskOrange,
                  child: AnimatedContainer(
                    width: orangeMaskWidth,
                    height: orangeMaskHeight,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                        color: kMainColorMicroInteraction,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),

              // This is the Sending message animated text
              AnimatedPositioned(
                duration: Duration(milliseconds: 1000),
                left: leftTextPosition,
                top: 20,
                curve: Curves.easeInOut,
                child: Opacity(
                  opacity: opacitySendingText,
                  child: AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Text(
                      'Sending',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    style: TextStyle(
                        color: Colors.white, letterSpacing: sendingTextSpacing),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
