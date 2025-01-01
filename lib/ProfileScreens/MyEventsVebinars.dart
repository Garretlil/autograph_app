import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class MyEventsVebinarsScreens extends StatefulWidget {
  final String courseName;
  const MyEventsVebinarsScreens({super.key, required this.courseName});

  @override
  State<MyEventsVebinarsScreens> createState() => _MyEventsVebinarsScreens();
}

class _MyEventsVebinarsScreens extends State<MyEventsVebinarsScreens> {
  final List<Map<String, String>> videos = [
    {'title': 'Color Correction Mastery', 'url': 'https://yandex.ru/video/preview/4978389184545378870'},
    {'title': 'Defects Removal Techniques', 'url': 'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_2mb.mp4'},
    {'title': 'Digital Signature Basics', 'url': 'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_3mb.mp4'},
  ];

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
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: VideoListItem(
                        title: videos[index]['title']!,
                        url: videos[index]['url']!,
                      ),
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

class VideoListItem extends StatefulWidget {
  final String title;
  final String url;

  const VideoListItem({super.key, required this.title, required this.url});

  @override
  State<VideoListItem> createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _videoPlayerController.initialize().then((_) {
      setState(() {});
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: false,
        looping: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.white70,
                child: _chewieController != null && _videoPlayerController.value.isInitialized
                    ? Chewie(controller: _chewieController!)
                    : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Center(
            child: Text(
              widget.title,
              style:  const TextStyle(fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,fontFamily: 'Inria Serif'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
