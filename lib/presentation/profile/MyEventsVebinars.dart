import 'dart:io';
import 'dart:ui';
import 'package:autograph_app/core/services/SharedP.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../AnimatedBackButton.dart';
import '../../Theme/SysTheme/Constants.dart';
import '../../data/models/purchased_course.dart';

class MyEventsWebinarsScreens extends StatefulWidget {
  final String courseName;
  final void Function(bool) toggleBottomNavigationBar;
  const MyEventsWebinarsScreens({super.key, required this.courseName,required this.toggleBottomNavigationBar});

  @override
  State<MyEventsWebinarsScreens> createState() => _MyEventsWebinarsScreens();
}

class _MyEventsWebinarsScreens extends State<MyEventsWebinarsScreens> {

  Map<String, List<Map<String, dynamic>>> videos = {};

  Shader createGradient(Rect bounds) {
    if (bounds.isEmpty) {
      return const LinearGradient(colors: [Colors.transparent, Colors.transparent]).createShader(bounds);
    }
    return const LinearGradient(
      colors: [Colors.orange, Colors.red],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds);
  }

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
              leading: FadedIconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => createGradient(bounds),
                    child: Text(
                      'AUTOGRAPH',
                      style: TextStyle(
                        fontSize: titleSizeFactor*0.9,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Inria Serif',
                      ),
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
              right: screenWidth*0.04,
          ),
          child:
          Column(children: [
            SizedBox(height: screenHeight * 0.00),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: screenHeight * 0.08,top: screenHeight * 0.12),
                itemCount: videos[widget.courseName]?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = videos[widget.courseName];
                  if (item == null) {
                    return const SizedBox.shrink();
                  }
                  print('$baseUrlFinal/video/${item[index]['id']}');
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: VideoPlayerView(
                                toggleBottomNavigationBar: widget.toggleBottomNavigationBar,
                                url: '$baseUrlFinal/courses/video/${item[index]['id']}',
                                thumbnailUrl: '$baseUrlFinal/static${item[index]['thumbnailUrl']}',
                                dataSourceType: DataSourceType.network,
                                duration: item[index]['duration'].toString(),
                                id: int.parse(item[index]['id']),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: screenWidth * 0.43,
                              child: Text(
                                item[index]['word'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Inria Serif',
                                  fontSize: spacingFactor * 0.27,
                                ),
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height:8),
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


enum DataSourceType {
  assets,
  network,
  file,
  contentUrl,
}

class VideoPlayerView extends StatefulWidget {
  final String url;
  final String thumbnailUrl;
  final DataSourceType dataSourceType;
  final void Function(bool) toggleBottomNavigationBar;
  final String duration;
  final int id;

  const VideoPlayerView({
    super.key,
    required this.url,
    required this.thumbnailUrl,
    required this.dataSourceType,
    required this.toggleBottomNavigationBar,
    required this.duration,
    required this.id,
  });

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  SharedPreferences? prefs;
  int watchMoment = 0;
  int hours=0;
  int minutes=0;
  int seconds=0;

  @override
  void initState() {
    super.initState();
    _loadWatchMoment();

  }

  Future<void> _loadWatchMoment() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      watchMoment = prefs?.getInt('video${widget.id}') ?? 0;
      print(watchMoment);
    });
  }


  void _openFullScreenPlayer(BuildContext context) async {
    widget.toggleBottomNavigationBar(false);

    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        maintainState: true,
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, animation, __) => FullScreenVideoPlayer(
          url: widget.url,
          dataSourceType: widget.dataSourceType,
          toggleBottomNavigationBar: widget.toggleBottomNavigationBar,
          videoId: widget.id,
          initialPosition: Duration(seconds: watchMoment),
        ),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );

    await _loadWatchMoment();
  }

  String convertToTime(int time) {
    final hours = time ~/ 3600;
    final minutes = (time % 3600) ~/ 60;
    final seconds = time % 60;
    twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '$minutes:${twoDigits(seconds)}';
    }
  }


  @override
  Widget build(BuildContext context) {
    final double totalDuration = double.tryParse(widget.duration) ?? 0.0;
    double screenWidth = MediaQuery.of(context).size.width;
    double titleSizeFactor = screenWidth * 0.06;
    print(totalDuration);
    return GestureDetector(
      onTap: () => _openFullScreenPlayer(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: widget.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Text(
                    'Ошибка загрузки',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleSizeFactor * 0.6,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white54.withOpacity(0.8),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(child: Text(' ${convertToTime(totalDuration.toInt())} ',style: TextStyle(color: Colors.black),)),
                ),
              ),
              Positioned(
                bottom: 1,
                left: 0,
                right: 0,
                child: CustomPaint(
                  painter: TimeLinePainter(
                    watchMoment: 0,
                    totalDuration: 1,
                    colorType: Colors.grey,
                    isFull: true,
                  ),
                ),
              ),
              Positioned(
                bottom: 1,
                left: 0,
                right: 0,
                child: CustomPaint(
                  painter: TimeLinePainter(
                    watchMoment: watchMoment,
                    totalDuration: totalDuration,
                    colorType: Colors.deepOrange,
                    isFull: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final String url;
  final DataSourceType dataSourceType;
  final void Function(bool) toggleBottomNavigationBar;
  final int videoId;
  final Duration initialPosition;

  const FullScreenVideoPlayer({
    super.key,
    required this.url,
    required this.dataSourceType,
    required this.toggleBottomNavigationBar,
    required this.videoId,
    required this.initialPosition,
  });

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    prefs = await SharedPreferences.getInstance();
    await _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    switch (widget.dataSourceType) {
      case DataSourceType.assets:
        _videoPlayerController = VideoPlayerController.asset(widget.url);
        break;
      case DataSourceType.network:
        _videoPlayerController = VideoPlayerController.network(
          widget.url,
          httpHeaders: {'x-session-key': AppPrefs.prefs.getString('session_key')!},
        );
        break;
      case DataSourceType.file:
        _videoPlayerController = VideoPlayerController.file(File(widget.url));
        break;
      case DataSourceType.contentUrl:
        _videoPlayerController = VideoPlayerController.contentUri(Uri.parse(widget.url));
        break;
    }

    await _videoPlayerController.initialize();

    await _videoPlayerController.seekTo(widget.initialPosition);

    int lastSavedSecond = -1;

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isInitialized &&
          _videoPlayerController.value.isPlaying) {
        final currentSecond = _videoPlayerController.value.position.inSeconds;
        if (currentSecond != lastSavedSecond && currentSecond % 5 == 0) {
          lastSavedSecond = currentSecond;
          prefs?.setInt('video${widget.videoId}', currentSecond);
        }
      }
    });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      showControls: true,
      allowFullScreen: true,
      allowMuting: true,
      allowPlaybackSpeedChanging: true,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
    );

    setState(() {
      _isInitialized = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chewieController?.enterFullScreen();
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            widget.toggleBottomNavigationBar(true);
          },
          child: Icon(Icons.close_sharp, size: screenWidth * 0.08, color: Colors.white70),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.only(bottom:screenH*0.14 ),
        child: Center(
          child: _isInitialized && _chewieController != null
              ? Chewie(controller: _chewieController!)
              : const CircularProgressIndicator.adaptive(backgroundColor: Colors.white),
        ),
      ),
    );
  }

}

class TimeLinePainter extends CustomPainter {
  final int watchMoment;
  final double totalDuration;
  final Color colorType;
  final bool isFull;

  TimeLinePainter({
    required this.watchMoment,
    required this.totalDuration,
    required this.colorType,
    required this.isFull,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorType
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    if (totalDuration <= 0) {
      canvas.drawLine(const Offset(0, 0), Offset(isFull ? size.width : 0, 0), paint);
      return;
    }

    double progressRatio = watchMoment / totalDuration;

    progressRatio = progressRatio.clamp(0.0, 1.0);

    final double progressWidth = isFull ? size.width : size.width * progressRatio;

    canvas.drawLine(
      const Offset(0, 0),
      Offset(progressWidth, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant TimeLinePainter oldDelegate) {
    return watchMoment != oldDelegate.watchMoment || totalDuration != oldDelegate.totalDuration;
  }
}



