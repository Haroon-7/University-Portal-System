import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:ups/login_signup/login.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      'assets/ups.mp4',
    )..initialize().then((_) {
      setState(() {});
      _playVideo();
    });

    // Make sure to dispose the controller when the widget is disposed.
    _controller.addListener(() {
      if (_controller.value.isPlaying) {
        setState(() {});
      }
    });
  }

  Future<void> _playVideo() async {
    await _controller.play();
    Timer(Duration(seconds: 7), () {
      // Navigate to the login page after 7 seconds (you can adjust the duration).
      Navigator.pushReplacementNamed(context, '/login'); // Replace with your login route.
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(), // You can display a loading indicator here
      ),
    );
  }
}


