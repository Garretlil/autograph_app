import 'dart:io';
import 'package:autograph_app/Consts.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../PurchasedСourses.dart';

class MyEventsVebinarsScreens extends StatefulWidget {
  final String courseName;
  const MyEventsVebinarsScreens({super.key, required this.courseName});

  @override
  State<MyEventsVebinarsScreens> createState() => _MyEventsVebinarsScreens();
}

class _MyEventsVebinarsScreens extends State<MyEventsVebinarsScreens> {
  final String code='2453';
  final Map<String, List<Map<String, dynamic>>> videos = PurchasedCourses.instance.getPurchasedWebinars();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Коэффициенты адаптации
    double paddingFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            paddingFactor*1.5,
            paddingFactor * 3,
            paddingFactor,
            0,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.deepOrange,
                    ),
                  ),
                  Text(
                    widget.courseName,
                    style: TextStyle(
                      fontSize: subtitleSizeFactor,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              //const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: videos[widget.courseName]?.length,
                  itemBuilder: (context, index) {
                    final item = videos[widget.courseName];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                         children: [
                           Text(item![index]['word'],style: TextStyle(
                               color: Colors.white,fontFamily: 'Inria Serif',fontSize:spacingFactor*0.4 )),
                           SizedBox(height: spacingFactor*0.2,),

                           VideoPlayerView(
                              url: '$baseUrlFinal/video/'+item[index]['id'],
                              thumbnailUrl: item[index]['preview_url']=='ttt'?
                              'assets/preview.png' : item[index]['preview_url'],
                              dataSourceType: DataSourceType.network,
                            ),
                         ]
                      )
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
            httpHeaders: { 'x-session-key': prefs?.getString('session_key')?? 'a55b540d-d85f-473d-9a03-5ff7ea46d30e'});
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

    // инициализация Chewie
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
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
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.deepOrange,
                        size: 45.0,
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
