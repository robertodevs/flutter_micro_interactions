import 'package:flutter/material.dart';

enum ToggleStatus {
  OFF,
  LOADING,
  ON,
}

class ToggleAnimatedScreen extends StatefulWidget {
  @override
  _ToggleAnimatedScreenState createState() => _ToggleAnimatedScreenState();
}

class _ToggleAnimatedScreenState extends State<ToggleAnimatedScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> height;

  /// Color transtition from OFF toggle
  /// loading transition
  Animation<Color> colorFromOffToLoading;

  /// Color transition from loading to ON
  Animation<Color> colorFromLoadingToON;

  /// toogle height
  Animation<double> toggleWidth;

  /// ON Background color
  Color offBackgroundColor = Color(0xFFFFE3E0);

  /// Loading background color
  Color loadingBackgroundColor = Color(0xFFDDE2FC);

  /// ON background color
  Color onBackgroundColor = Color(0xFFE7FCEE);

  /// Off Color
  Color offColor = Color(0xFFE44B46);

  /// Loading Color
  Color loadingColor = Colors.grey;

  /// Loading Circular Progress Color
  Color loadingCircularColor = Color(0xFF7A84EB);

  /// On Color
  Color onColor = Color(0xFF60CA79);

  /// Actual Status animation
  ToggleStatus animationStatus = ToggleStatus.OFF;

  /// toogle is on
  bool isOn = false;

  /// isLoading flag
  bool replay = false;

  /// Status text
  String statusText = 'Devices Off';

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _controller.addListener(() {
      // Listen the actual status of the animation.
      // First 25% of the animation.
      if (_controller.value <= 0.25) {
        animationStatus = ToggleStatus.OFF;
        statusText = 'Devices Off';
        isOn = false;

        // From 25% to 75%.
      } else if (_controller.value >= 0.25 && _controller.value <= 0.75) {
        // Modify this if it will be implemented a call function
        if (!replay) _controller.stop();
        // Change the status until de callback is completed.

        animationStatus = ToggleStatus.LOADING;
        statusText = 'Please wait...';
        loadingColor = onColor;

        // From 75% to 100%.
      } else {
        statusText = 'Devices On';
        animationStatus = ToggleStatus.ON;
        isOn = true;
      }
      setState(() {});
    });

    //_controller.forward();

    // Each animation defined here transforms its value during the subset
    // of the controller's duration defined by the animation's interval.
    // For example the opacity animation transforms its value during
    // the first 10% of the controller's duration.

    colorFromOffToLoading = ColorTween(begin: offColor, end: loadingColor)
        .animate(new CurvedAnimation(
            parent: _controller,
            curve: Interval(
              0.20,
              0.25,
              curve: Curves.easeInOut,
            )));

    colorFromLoadingToON = ColorTween(begin: loadingColor, end: onColor)
        .animate(new CurvedAnimation(
            parent: _controller,
            curve: Interval(
              0.70,
              0.75,
              curve: Curves.easeInOut,
            )));

    toggleWidth = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 100.0, end: 50.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(50.0),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 50.0, end: 100.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 25.0,
        ),
      ],
    ).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offBackgroundColor,
      body: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInToLinear,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      // When is On, the animation is completed
                      // so when is tapping again is
                      if (isOn) {
                        // Play to the animation
                        _controller.reverse();

                        // Add your function call here
                        await Future.delayed(Duration(milliseconds: 2000));

                        // When the future event is completed
                        // proceed to complete the animation
                        replay = true;
                        _controller.reverse();
                      } else {
                        // Play to the animation
                        _controller.forward();

                        // Add your function call here
                        await Future.delayed(Duration(milliseconds: 2000));

                        // When the future event is completed
                        // proceed to complete the animation
                        replay = true;
                        _controller.forward();
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _controller.view,
                      builder: (context, child) {
                        return Stack(
                          children: <Widget>[
                            Container(
                              width: toggleWidth.value,
                              height: 50,
                              child: AnimatedAlign(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                alignment:
                                    animationStatus == ToggleStatus.LOADING
                                        ? Alignment.center
                                        : animationStatus == ToggleStatus.OFF
                                            ? Alignment.centerLeft
                                            : Alignment.centerRight,
                                child: Container(
                                  width: 50,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0, 5),
                                            blurRadius: 10)
                                      ],
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: animationStatus != ToggleStatus.ON
                                      ? colorFromOffToLoading.value
                                      : colorFromLoadingToON.value),
                            ),
                            child
                          ],
                        );
                      },
                      child: animationStatus == ToggleStatus.LOADING
                          ? AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                valueColor: AlwaysStoppedAnimation(
                                    loadingCircularColor),
                              ),
                            )
                          : SizedBox(
                              height: 0,
                            ),
                    )),
                SizedBox(
                  width: 30,
                ),
                // Here is the status text labels
                // Devices Off. Loading. Devices On
                Container(
                    width: 120,
                    child: Text(statusText,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4)))
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
            color: animationStatus == ToggleStatus.OFF
                ? offBackgroundColor
                : animationStatus == ToggleStatus.LOADING
                    ? loadingBackgroundColor
                    : onBackgroundColor),
      ),
    );
  }
}
