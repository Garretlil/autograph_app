import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../core/Constants.dart';
import '../../data/models/purchased_course.dart';

class MyEventsWebinarsScreens extends StatefulWidget {
  final String courseName;
  const MyEventsWebinarsScreens({super.key, required this.courseName});

  @override
  State<MyEventsWebinarsScreens> createState() => _MyEventsWebinarsScreens();
}

class _MyEventsWebinarsScreens extends State<MyEventsWebinarsScreens> {
  final String code = '2453';

  Map<String, List<Map<String, dynamic>>> videos = {};

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final fetchedVideos = await PurchasedCourses.instance.loadPurchasedFromServer();
    setState(() {
      videos = fetchedVideos;
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size(
          screenWidth,
          kToolbarHeight-20,
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                color: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'AUTOGRAPH',
                    style: TextStyle(
                      fontSize: titleSizeFactor * 0.85,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(padding: EdgeInsets.only(
              left: screenWidth*0.04,
              right: screenWidth*0.04
          ),
          child:
          Column(children: [
            SizedBox(height: screenHeight * 0.03),
            Expanded(
              child: ListView.builder(
                itemCount: videos[widget.courseName]?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = videos[widget.courseName];
                  if (item == null) {
                    return const SizedBox.shrink();
                  }
                  print('$baseUrlFinal/video/${item[index]['id']}');
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: VideoPlayerView(
                                url: '$baseUrlFinal/video/${item[index]['id']}',
                                thumbnailUrl: 'assets/fon2.png',
                                dataSourceType: DataSourceType.network,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: screenWidth * 0.4,
                              child: Text(
                                item[index]['word'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Inria Serif',
                                  fontSize: spacingFactor * 0.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        index != item.length - 1
                            ? const Divider()
                            : const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
                ),
              ]
            )
          )
        ],
      ),
    );
  }
}

class VideoPlayerView extends StatefulWidget{
  const VideoPlayerView ({
    super.key,
    required this.url,
    required this.thumbnailUrl,
    required this.dataSourceType,
  });
  final String url;
  final DataSourceType dataSourceType;
  final String thumbnailUrl;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isVideoPlaying = false;
  late Duration videoDuration;
  SharedPreferences? prefs;
  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
    _init();
  }
  Future<void> _init() async {
    prefs = await SharedPreferences.getInstance();
    await _initializeVideoPlayer();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setPref();
    _initializeVideoPlayer();
    videoDuration = _videoPlayerController.value.duration;
  }

  Future<void> _initializeVideoPlayer() async {
    switch (widget.dataSourceType) {
      case DataSourceType.assets:
        _videoPlayerController = VideoPlayerController.asset(widget.url);
        break;
      case DataSourceType.network:
        print(prefs?.getString('session_key'));
        _videoPlayerController = VideoPlayerController.network(widget.url,
            httpHeaders: { 'x-session-key': prefs?.getString('session_key')?? 'fake_key'});
        print(widget.url);
        break;
      case DataSourceType.file:
        _videoPlayerController = VideoPlayerController.file(File(widget.url));
        break;
      case DataSourceType.contentUrl:
        _videoPlayerController = VideoPlayerController.contentUri(Uri.parse(widget.url));
        break;
    }

    _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.white70,
        handleColor: Colors.white70,
        backgroundColor: Colors.white24,
        bufferedColor: Colors.grey.shade300,
      ),
    );

    _videoPlayerController.addListener(() {
      setState(() {
        if (_videoPlayerController.value.position == _videoPlayerController.value.duration) {
          _isVideoPlaying = false;
        }
      });
    });
    setState(() {});
    _chewieController.addListener(() {
      if (!_chewieController.isFullScreen) {
        _chewieController.pause();
        _isVideoPlaying = false;
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _playVideo() {
    setState(() {
      _isVideoPlaying = true;
    });
    _videoPlayerController.play();
    _chewieController.enterFullScreen();
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Chewie(controller: _chewieController),
                if (!_isVideoPlaying)
                  GestureDetector(
                    onTap: _playVideo,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.thumbnailUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child:  Icon(
                        Icons.play_circle_outline,
                        color: Colors.white.withOpacity(0.8),
                        size: 35.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum DataSourceType {
  assets,
  network,
  file,
  contentUrl
}
