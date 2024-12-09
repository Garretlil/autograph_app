import 'package:flutter/material.dart';


class EventsOnline extends StatefulWidget {
  const EventsOnline({super.key});

  @override
  State<EventsOnline> createState() => _EventsOnline();
}

class _EventsOnline extends State<EventsOnline> {
  @override
  void initState() {
    super.initState();
  }

  List<Map<String, String>> listOfCatalogsForOnlineEvents = [
    {
      'PRO DESIGN': 'Full demonstration of photo editing,'
          ' including color correction, defects removal,'
          ' creating own brand logo,'
          ' digital signature and etc.',
    },
    {
      'PRO PHOTO': 'The largest review of cameras,'
          ' photosets for different budget, dental photography,'
          ' all about macro, manual stacking and usage of macrorails,'
          ' camera flash analysis and etc.',
    },
    {
      'LIGHT MASTER': 'Comprehensive guide to using studio lighting,'
          ' outdoor lighting setups, and controlling natural light. '
          'Tips for budget and professional setups.',
    },
    {
      'VIDEO ART': 'Learn video editing, color grading,'
          ' and cinematic techniques. Covers tools like Premiere Pro,'
          ' DaVinci Resolve, and After Effects.',
    },
    {
      'MOBILE PHOTO': 'Photography tips and tricks for smartphones,'
          ' including using advanced apps, lens attachments, and'
          ' post-processing on mobile devices.',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
            12.0 * MediaQuery.of(context).devicePixelRatio,
            15.0 * MediaQuery.of(context).devicePixelRatio,
            12.0 * MediaQuery.of(context).devicePixelRatio,
            0.0 * MediaQuery.of(context).devicePixelRatio,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Верхняя панель с кнопкой назад
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Возврат на предыдущий экран
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 10.0 * MediaQuery.of(context).devicePixelRatio,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'AUTOGRAPH ',
                        style: TextStyle(
                          fontSize: 6.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'EVENTS',
                        style: TextStyle(
                          fontSize: 20.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'ONLINE',
                        style: TextStyle(
                          fontSize: 10.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24), // Пустое место справа для баланса
                ],
              ),
              SizedBox(height: 1.0 * MediaQuery.of(context).devicePixelRatio),
              Expanded(
                child: ListView.builder(
                  itemCount: listOfCatalogsForOnlineEvents.length,
                  itemBuilder: (context, index) {
                    final item = listOfCatalogsForOnlineEvents[index];
                    return GestureDetector(
                      onTap: () {
                        // Действие при нажатии на карточку
                        Navigator.pushNamed(
                          context,
                          '/DetailsScreenForSection',
                          arguments: {
                            'section': item.keys.first,
                          },
                        );
                      },
                      child: Card(
                        color: Colors.black.withOpacity(0.2),
                        // Полупрозрачный фон
                        margin: EdgeInsets.symmetric(
                          vertical: 5.0 * MediaQuery.of(context).devicePixelRatio,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                            5.0 * MediaQuery.of(context).devicePixelRatio,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.keys.first,
                                style: TextStyle(
                                  fontSize:
                                  10.0 * MediaQuery.of(context).devicePixelRatio,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Inria Serif',
                                ),
                              ),
                              SizedBox(
                                  height: 2.0 *
                                      MediaQuery.of(context).devicePixelRatio),
                              Text(
                                item.values.first,
                                style: TextStyle(
                                  fontSize:
                                  8.0 * MediaQuery.of(context).devicePixelRatio,
                                  color: Colors.white70,
                                  fontFamily: 'Inria Serif',
                                ),
                              ),
                            ],
                          ),
                        ),
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

